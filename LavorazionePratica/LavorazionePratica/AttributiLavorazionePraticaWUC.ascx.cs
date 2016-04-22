using ClassiDiBusiness.DAL;
using ClassiDiBusiness.Pratiche;
using System;

namespace LamaVetWeb.Pratiche.LavorazionePratica
{
    public partial class AttributesLavorazionePraticaWUC : System.Web.UI.UserControl
    {
        public LavorazionePraticaManager lManager;

        public class LavorazionePraticaEventArgs : EventArgs
        {
            public AttributoSelezionato Attributo { get; set; }

            public LavorazionePraticaEventArgs(AttributoSelezionato val)
            {
                this.Attributo = val;
            }
        }

        public int idTipoLavorazione { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public string GetidlManager()
        {
            return hfidlManager.Value;
        }
        public void SetidlManager(string value)
        {
            hfidlManager.Value = value;
        }

        public void Inizializza(LavorazionePraticaManager lpManager, bool SaveCache = true)
        {
            lManager = lpManager;
            if (SaveCache)
                Session["lManager"] = lManager;
        }

        public void RimuoviManagerDaCache()
        {
            if (Session["lManager"] != null)
            {
                Session.Remove("lManager");
                lManager = null;
            }
        }

        public void ResetDati()
        {
            hfIdAttrSel.Value = null;
            tbValoreAttributo.Text = null;
        }

        public bool Salva(object allegato, int newIdPraticaInbound)
        {
            tipiLavorazione TipoLav = (tipiLavorazione)allegato;
            try
            {
                DataSetLavorazioni.LavorazioniPraticheRow lavPra = lManager.DRLavorazioniPratiche;
                switch (TipoLav)
                {
                    case tipiLavorazione.RinnovoContratto:
                        lavPra.idPraticaInbound = newIdPraticaInbound;
                        lManager.Salva(TipoLav);
                        return true;
                        break;
                    case tipiLavorazione.FatturaInsoluta:
                        lavPra.idPratica = newIdPraticaInbound;
                        lManager.Salva(TipoLav);
                        return true;
                        break;
                    default:
                        return false;
                        break;
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}