<%@ WebHandler Language="C#" Class="LavorazioniPraticaHandler" %>

using System;
using System.Web;
using System.Collections.Specialized;
using System.IO;
using ClassiDiBusiness.Pratiche;
using Newtonsoft.Json;

public class LavorazioniPraticaHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    LavorazionePraticaManager lManager;

    private class jsonResult
    {
        public int idlManager { get; set; }
        public AttributesCategorie AttributesValidi { get; set; }
        public AttributesLavorazione AttributesLavorazione { get; set; }
    }

    public void ProcessRequest(HttpContext context)
    {

        context.Response.ContentType = "application/json; charset=utf-8";
        context.Request.InputStream.Position = 0;
        NameValueCollection dataPOST = null;
        int idlManager = 0;
        int idAttributo;
        string ValoreAttributo;
        string operazione;
        bool result;
        try
        {
            using (var inputStream = new StreamReader(context.Request.InputStream))
            {
                dataPOST = HttpUtility.ParseQueryString(HttpUtility.HtmlDecode(inputStream.ReadToEnd().Replace("&quot;", "\\&quot;")));
            }

            if (dataPOST != null)
            {
                result = Int32.TryParse(dataPOST["idlManager"], out idlManager);
                operazione = dataPOST["Operazione"];
                result = Int32.TryParse(dataPOST["idAttributo"], out idAttributo);
                ValoreAttributo = dataPOST["ValoreAttributo"];

                lManager = (LavorazionePraticaManager)context.Session["lManager"];
                if (lManager == null)
                    lManager = new LavorazionePraticaManager(-1, tipiLavorazione.FatturaInsoluta);
                
                switch (operazione)
                {
                    case "Inizializza":
                        //serve a caricare gli Attributes eventualmente già selezionati nei round precedenti
                        break;
                    case "AggiungiAttributo":
                        AggiungiAttributo(idAttributo, ValoreAttributo);
                        break;
                    case "EliminaAttributo":
                        EliminaAttributo(idAttributo);
                        break;
                    case "AggiungiCategoriaEsclusa":
                        AggiungiCategoriaEsclusa(idAttributo);
                        break;
                    case "RimuoviCategoriaEsclusa":
                        RimuoviCategoriaEsclusa(idAttributo);
                        break;
                    case "ClearCategorieEscluse":
                        ClearCategorieEscluse();
                        break;
                    case "AggiungiAttributoEscluso":
                        AggiungiAttributoEscluso(idAttributo);
                        break;
                    case "RimuoviAttributoEscluso":
                        RimuoviAttributoEscluso(idAttributo);
                        break;
                    case "ClearAttributesEsclusi":
                        ClearAttributesEsclusi();
                        break;
                    default:
                        break;
                }

                AttributesLavorazione AttributesLav = lManager.GetAttributesSelezionati();
                if (AttributesLav.AttributesSelezionati.Count <= 0)
                {
                    //aggiungo la riga di cortesia
                    AttributoSelezionato att = new AttributoSelezionato();
                    att.idAttributo = -1;
                    att.Valore = null;
                    lManager.AddAttributoLavorazione(att);
                }

                context.Session["lManager"] = lManager;
                
                jsonResult JsonResult = new jsonResult();
                JsonResult.idlManager = idlManager;
                JsonResult.AttributesLavorazione = lManager.GetAttributesSelezionati();
                JsonResult.AttributesValidi = lManager.GetAttributesValidi();
                context.Response.Write(JsonConvert.SerializeObject(JsonResult));
            }
        }
        catch (Exception)
        {

            throw;
        }

    }

    private void AggiungiAttributo(int idAttributo, string ValoreAttributo)
    {
        AttributesLavorazione attrSel = lManager.GetAttributesSelezionati();
        AttributoSelezionato attibutoDel = new AttributoSelezionato();
        attibutoDel.idAttributo = -1;
        //se sto aggiungendo il primo attributo elimino l'attributo finto cool messaggio di cortesia.
        if (attrSel.AttributesSelezionati.Contains(attibutoDel))
        {
            lManager.RemoveAttributoLavorazione(attibutoDel);
        }
        AttributoSelezionato att = new AttributoSelezionato();
        att.idAttributo = idAttributo;
        att.Valore = string.IsNullOrEmpty(ValoreAttributo) ? null : ValoreAttributo;
        lManager.AddAttributoLavorazione(att);
    }

    private void EliminaAttributo(int idAttributo)
    {
        AttributoSelezionato att = new AttributoSelezionato();
        att.idAttributo = idAttributo;
        lManager.RemoveAttributoLavorazione(att);
    }

    private void AggiungiCategoriaEsclusa(int idCategoria)
    {
        CategoriaAttributes cat = new CategoriaAttributes();
        cat.idCategoria = idCategoria;
        lManager.AddEsclusioneCategorie(cat);
    }

    private void RimuoviCategoriaEsclusa(int idCategoria)
    {
        CategoriaAttributes cat = new CategoriaAttributes();
        cat.idCategoria = idCategoria;
        lManager.RemoveEsclusioneCategorie(cat);
    }

    private void ClearCategorieEscluse()
    {
        lManager.ClearEsclusioneCategorie();
    }

    private void AggiungiAttributoEscluso(int idAttributo)
    {
        AttributoSelezionato att = new AttributoSelezionato();
        att.idAttributo = idAttributo;
        lManager.AddEsclusioneAttributes(att);
    }

    private void RimuoviAttributoEscluso(int idAttributo)
    {
        AttributoSelezionato att = new AttributoSelezionato();
        att.idAttributo = idAttributo;
        lManager.RemoveEsclusioneAttributes(att);
    }

    private void ClearAttributesEsclusi()
    {
        lManager.ClearEsclusioneAttributes();
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}