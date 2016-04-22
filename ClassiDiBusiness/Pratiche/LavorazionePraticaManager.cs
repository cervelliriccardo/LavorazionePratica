using ClassiDiBusiness.DAL;
using ClassiDiBusiness.DAL.DataSetLavorazioniTableAdapters;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace ClassiDiBusiness.Pratiche
{
    public enum tipiLavorazione
    {
        RinnovoContratto = 1,
        FatturaInsoluta = 2        
    }

    public class Attributo : IEquatable<Attributo>
    {
        public int idCategoria { get; set; }
        public int idAttributo { get; set; }
        public string Descrizione { get; set; }
        public bool HasValore { get; set; }
        public string DescrizioneValore { get; set; }

        public override bool Equals(object obj)
        {
            if (obj == null) return false;
            Attributo objAsPart = obj as Attributo;
            if (objAsPart == null) return false;
            else return Equals(objAsPart);
        }
        public override int GetHashCode()
        {
            return idAttributo;
        }
        public bool Equals(Attributo other)
        {
            if (other == null) return false;
            return (this.idAttributo.Equals(other.idAttributo));
        }
    }

    public class AttributoSelezionato : IEquatable<AttributoSelezionato>
    {
        public int idAttributo { get; set; }
        public string DescrizioneCategoria { get; set; }
        public string Descrizione { get; set; }
        public bool HasValore { get; set; }
        public string Valore { get; set; }

        public override bool Equals(object obj)
        {
            if (obj == null) return false;
            AttributoSelezionato objAsPart = obj as AttributoSelezionato;
            if (objAsPart == null) return false;
            else return Equals(objAsPart);
        }
        public override int GetHashCode()
        {
            return idAttributo;
        }
        public bool Equals(AttributoSelezionato other)
        {
            if (other == null) return false;
            return (this.idAttributo.Equals(other.idAttributo));
        }
    }

    public class CategoriaAttributi : IEquatable<CategoriaAttributi>
    {
        public int idCategoria { get; set; }
        public string Descrizione { get; set; }
        public List<Attributo> Attributi { get; set; }

        public CategoriaAttributi()
        {
            Attributi = new List<Attributo>();
        }

        public override bool Equals(object obj)
        {
            if (obj == null) return false;
            CategoriaAttributi objAsPart = obj as CategoriaAttributi;
            if (objAsPart == null) return false;
            else return Equals(objAsPart);
        }
        public override int GetHashCode()
        {
            return idCategoria;
        }
        public bool Equals(CategoriaAttributi other)
        {
            if (other == null) return false;
            return (this.idCategoria.Equals(other.idCategoria));
        }
    }

    public class AttributiCategorie
    {
        public List<CategoriaAttributi> CategorieAttributi { get; set; }

        public AttributiCategorie()
        {
            CategorieAttributi = new List<CategoriaAttributi>();
        }
    }

    public class AttributiLavorazione
    {
        public List<AttributoSelezionato> AttributiSelezionati { get; set; }

        public AttributiLavorazione()
        {
            AttributiSelezionati = new List<AttributoSelezionato>();
        }
    }

    public class CategorieDaEscludere
    {
        public HashSet<CategoriaAttributi> CategorieEscluse { get; set; }

        public CategorieDaEscludere()
        {
            CategorieEscluse = new HashSet<CategoriaAttributi>();
        }
    }

    public class AttrubutiDaEscludere
    {
        public HashSet<AttributoSelezionato> AttributiEsclusi { get; set; }

        public AttrubutiDaEscludere()
        {
            AttributiEsclusi = new HashSet<AttributoSelezionato>();
        }
    }

    [System.Serializable]
    public class LavorazionePraticaManager
    {
        private int idPratica;
        public DataSetLavorazioni DSLavorazioni;
        private DataSetLavorazioni DSLavorazioniRollback;
        private CategorieDaEscludere RichiestaEsclusioneCategorie;
        private AttrubutiDaEscludere RichiestaEsclusioneAttributi;


        #region costruttori

        public LavorazionePraticaManager()
        {
        }

        public LavorazionePraticaManager(int idPratica, tipiLavorazione tipoLavorazione)
        {
            this.idPratica = idPratica;
            DSLavorazioni = new DataSetLavorazioni();
            RichiestaEsclusioneCategorie = new CategorieDaEscludere();
            RichiestaEsclusioneAttributi = new AttrubutiDaEscludere();
            LavorazioniPraticheTableAdapter TALavPratica = new LavorazioniPraticheTableAdapter();
            LavorazioneAttributiTableAdapter TalavAtt = new LavorazioneAttributiTableAdapter();
            EsclusioniCategorieTableAdapter TaEsclCat = new EsclusioniCategorieTableAdapter();
            EsclusioniAttributiTableAdapter TaEsclAttr = new EsclusioniAttributiTableAdapter();
            AttributiTableAdapter TaAttributi = new AttributiTableAdapter();
            CategorieAttributiTableAdapter TaCategorie = new CategorieAttributiTableAdapter();

            try
            {
                TaEsclCat.FillByIdTipoCategoria(DSLavorazioni.EsclusioniCategorie, (int)tipoLavorazione);
                TaEsclAttr.FillByIdTipoCategoria(DSLavorazioni.EsclusioniAttributi, (int)tipoLavorazione);
                if (tipoLavorazione == tipiLavorazione.RinnovoContratto)
                {
                    TALavPratica.FillByidPraticaInbound(DSLavorazioni.LavorazioniPratiche, idPratica);
                }
                else
                {
                    TALavPratica.FillByIdPratica(DSLavorazioni.LavorazioniPratiche, idPratica);
                }
                TaAttributi.FillByIdTipoLavorazione(DSLavorazioni.Attributi, (int)tipoLavorazione);
                TaCategorie.FillByIdTipoLavorazione(DSLavorazioni.CategorieAttributi, (int)tipoLavorazione);
                if (DSLavorazioni.LavorazioniPratiche.Count > 0)
                {
                    TalavAtt.FillByLavorazionePratica(DSLavorazioni.LavorazioneAttributi, DSLavorazioni.LavorazioniPratiche[0].idLavorazionePratica);
                }
                if (DSLavorazioni.LavorazioniPratiche.Count == 0)
                {
                    DataSetLavorazioni.LavorazioniPraticheRow row = GetNuovaRigaLavorazioniPratiche();
                    if (tipoLavorazione == tipiLavorazione.RinnovoContratto)
                    {
                        row.idPraticaInbound = idPratica;
                    }
                    else
                    {
                        row.idPratica = idPratica;
                    }
                    row.DataInserimento = DateTime.Now;
                    row.UtenteInserimento = 1; 
                    row.TipoLavorazione = (int)tipoLavorazione;
                    InserisciNuovaRigaLavorazioniPratiche(row);
                }
            }
            catch (Exception)
            {

                throw;
            }
            finally
            {
                TALavPratica.Dispose();
                TalavAtt.Dispose();
                TaEsclCat.Dispose();
                TaEsclAttr.Dispose();
                TaAttributi.Dispose();
                TaCategorie.Dispose();
            }
        }

        public void Inizializza()
        {
            if (DSLavorazioni == null) DSLavorazioni = new DataSetLavorazioni();
            if (RichiestaEsclusioneAttributi == null) RichiestaEsclusioneAttributi = new AttrubutiDaEscludere();
        }

        #endregion

        #region Proprietà

        public DataSetLavorazioni.LavorazioniPraticheRow DRLavorazioniPratiche
        {
            get { return DSLavorazioni.LavorazioniPratiche[0]; }
        }

        #endregion

        #region Gestione Dato

        public DataSetLavorazioni.LavorazioniPraticheRow GetNuovaRigaLavorazioniPratiche()
        {
            DataSetLavorazioni.LavorazioniPraticheRow dr = DSLavorazioni.LavorazioniPratiche.NewLavorazioniPraticheRow();
            return dr;
        }

        public DataSetLavorazioni.LavorazioniPraticheRow GetRigaLavorazioniPratiche(int idLavorazionePratica)
        {
            if (DSLavorazioni.LavorazioniPratiche.Count == 0) return null;
            DataSetLavorazioni.LavorazioniPraticheRow dr = DSLavorazioni.LavorazioniPratiche.FindByidLavorazionePratica(idLavorazionePratica);
            return dr;
        }

        public void InserisciNuovaRigaLavorazioniPratiche(DataSetLavorazioni.LavorazioniPraticheRow dr)
        {
            DSLavorazioni.LavorazioniPratiche.AddLavorazioniPraticheRow(dr);
        }

        public void AddAttributoLavorazione(AttributoSelezionato AttrIn)
        {
            try
            {
                DataSetLavorazioni.LavorazioneAttributiRow rigaLavAtt = DSLavorazioni.LavorazioneAttributi.NewLavorazioneAttributiRow();
                rigaLavAtt.LavorazionePratica = DRLavorazioniPratiche.idLavorazionePratica;
                rigaLavAtt.AttributoLavorazione = AttrIn.idAttributo;
                rigaLavAtt.DataInserimento = DateTime.Now;
                rigaLavAtt.Valore = AttrIn.Valore;
                DSLavorazioni.LavorazioneAttributi.AddLavorazioneAttributiRow(rigaLavAtt);
            }
            catch (Exception)
            {

            }

        }

        public void RemoveAttributoLavorazione(AttributoSelezionato attIn)
        {
            try
            {
                DataSetLavorazioni.LavorazioneAttributiRow rigaLavAtt = DSLavorazioni.LavorazioneAttributi.FindByLavorazionePraticaAttributoLavorazione(DRLavorazioniPratiche.idLavorazionePratica, attIn.idAttributo);
                DSLavorazioni.LavorazioneAttributi.RemoveLavorazioneAttributiRow(rigaLavAtt);
            }
            catch (Exception)
            {

            }
        }

        public void AddEsclusioneCategorie(CategoriaAttributi CatIn)
        {
            this.RichiestaEsclusioneCategorie.CategorieEscluse.Add(CatIn);
        }

        public void AddEsclusioneAttributi(AttributoSelezionato AttrIn)
        {
            this.RichiestaEsclusioneAttributi.AttributiEsclusi.Add(AttrIn);
        }

        public void RemoveEsclusioneCategorie(CategoriaAttributi CatIn)
        {
            this.RichiestaEsclusioneCategorie.CategorieEscluse.Remove(CatIn);
        }

        public void RemoveEsclusioneAttributi(AttributoSelezionato AttrIn)
        {
            this.RichiestaEsclusioneAttributi.AttributiEsclusi.Remove(AttrIn);
        }

        public void ClearEsclusioneCategorie()
        {
            this.RichiestaEsclusioneCategorie.CategorieEscluse.Clear();
        }

        public void ClearEsclusioneAttributi()
        {
            this.RichiestaEsclusioneAttributi.AttributiEsclusi.Clear();
        }

        public AttributiLavorazione GetAttributiSelezionati()
        {
            DataTable LavorazAttr = DSLavorazioni.Tables["LavorazioneAttributi"];
            DataTable Attributi = DSLavorazioni.Tables["Attributi"];
            DataTable Categorie = DSLavorazioni.Tables["CategorieAttributi"];

            var AttributiSelezionati =
                from lat in LavorazAttr.AsEnumerable()
                join attsel in Attributi.AsEnumerable()
                  on lat.Field<int>("AttributoLavorazione") equals attsel.Field<int>("idAttributo")
                join categoria in Categorie.AsEnumerable() on attsel.Field<int>("Categoria") equals categoria.Field<int>("idCategoria")
                select new
                {
                    idAttributo = attsel.Field<int>("idAttributo"),
                    DescrizioneAttributo = attsel.Field<string>("Descrizione"),
                    DescrizioneCategoria = categoria.Field<string>("Descrizione"),
                    hasValore = attsel.Field<bool>("HasValue"),
                    Valore = lat.Field<string>("Valore")
                };

            AttributiLavorazione result = new AttributiLavorazione();

            foreach (var attributoSel in AttributiSelezionati)
            {
                AttributoSelezionato att = new AttributoSelezionato();
                att.DescrizioneCategoria = attributoSel.DescrizioneCategoria;
                att.idAttributo = attributoSel.idAttributo;
                att.Descrizione = attributoSel.DescrizioneCategoria + "\\" + attributoSel.DescrizioneAttributo + (attributoSel.hasValore ? "(" + attributoSel.Valore + ")" : null);
                att.HasValore = attributoSel.hasValore;
                att.Valore = attributoSel.Valore;
                result.AttributiSelezionati.Add(att);
            }
            return result;
        }

        public AttributiCategorie GetAttributiValidi()
        {
            /* La funzione ritorna gli attributi che si devono mostrare nella sezione degli attributi disponibili.
             * Gli attributi vengono filtrati (in base a quelli già selezionati e) in base alla configurazione delle esclusioni
             * 
             * Le categorie e gli attributi sono già filtrati per il tipo lavorazione. 
             * devo solo escludere le categorie e gli attributi non compatibili con quelli già selezionati. Aggiunta l'esclusione di attributi imposta da web.
             * 
             * la query è questa:
             * select * from LAVAttributi at
             *  where at.Categoria not in (select escat.CategoriaEsclusa from LAVLavorazioneAttributi lat join LAVAttributi attsel on lat.AttributoLavorazione = attsel.idAttributo
			 *	 join LAVEsclusioniCategorie escat on attsel.Categoria = escat.Categoria)
             *    and at.idAttributo not in (select esat.AttributoEscluso from LAVLavorazioneAttributi lat join LAVEsclusioniAttributi esat on lat.AttributoLavorazione = esat.Attributo)
             *    and at.idAttributo not in (lista degli attributi esclusi da funzionalità web)
             */
            DataTable Attributi = DSLavorazioni.Tables["Attributi"];
            DataTable Categorie = DSLavorazioni.Tables["CategorieAttributi"];
            DataTable LavorazAttr = DSLavorazioni.Tables["LavorazioneAttributi"];
            DataTable EsclusioneCategorie = DSLavorazioni.Tables["EsclusioniCategorie"];
            DataTable EsclusioneAttributi = DSLavorazioni.Tables["EsclusioniAttributi"];

            var AttributiValidi =
                from attributi in Attributi.AsEnumerable()
                join categoria in Categorie.AsEnumerable() on attributi.Field<int>("Categoria") equals categoria.Field<int>("idCategoria")
                where !(from lat in LavorazAttr.AsEnumerable()
                        join attsel in Attributi.AsEnumerable()
                          on lat.Field<int>("AttributoLavorazione") equals attsel.Field<int>("idAttributo")
                        join escat in EsclusioneCategorie.AsEnumerable()
                          on attsel.Field<int>("Categoria") equals escat.Field<int>("Categoria")
                        select escat.Field<int>("CategoriaEsclusa")
                        ).Contains(attributi.Field<int>("Categoria")) //esclusione delle categorie mutuamente esclusive
                   && !(from cat_web in this.RichiestaEsclusioneCategorie.CategorieEscluse
                        select cat_web.idCategoria
                        ).Contains(attributi.Field<int>("Categoria")) //esclusione delle categorie richieste da funzionalità
                   && !(from lat2 in LavorazAttr.AsEnumerable()
                        join esat in EsclusioneAttributi.AsEnumerable() on lat2.Field<int>("AttributoLavorazione") equals esat.Field<int>("Attributo")
                        select esat.Field<int>("AttributoEscluso")
                        ).Contains(attributi.Field<int>("idAttributo")) //esclusione degli attributi mutuamente esclusi
                   && !(from lat3 in LavorazAttr.AsEnumerable()
                        select lat3.Field<int>("AttributoLavorazione")
                        ).Contains(attributi.Field<int>("idAttributo")) //Esclusione degli attributi già selezionati
                   && !(from atr_web in this.RichiestaEsclusioneAttributi.AttributiEsclusi
                        select atr_web.idAttributo
                        ).Contains(attributi.Field<int>("idAttributo")) //Esclusione degli attributi richiesti da funzionalità 
                orderby categoria.Field<int>("Ordine"), attributi.Field<int>("idAttributo")
                select new
                {
                    CategoriaId = attributi.Field<int>("Categoria"),
                    DescrizioneCategoria = categoria.Field<string>("Descrizione"),
                    idAttributo = attributi.Field<int>("idAttributo"),
                    DescrizioneAttributo = attributi.Field<string>("Descrizione"),
                    HasValore = attributi.Field<bool>("HasValue"),
                    DescrizioneValore = attributi.Field<string>("DescrizioneValore")
                };

            AttributiCategorie result = new AttributiCategorie();
            int idCategoriaAtt = -100;
            CategoriaAttributi Categoria = null;
            foreach (var attributiOk in AttributiValidi)
            {
                if (attributiOk.CategoriaId != idCategoriaAtt)
                {
                    Categoria = new CategoriaAttributi();
                    Categoria.idCategoria = attributiOk.CategoriaId;
                    Categoria.Descrizione = attributiOk.DescrizioneCategoria;
                    result.CategorieAttributi.Add(Categoria);
                }
                idCategoriaAtt = attributiOk.CategoriaId;
                Attributo att = new Attributo();
                att.idCategoria = attributiOk.CategoriaId;
                att.idAttributo = attributiOk.idAttributo;
                att.Descrizione = attributiOk.DescrizioneAttributo;
                att.HasValore = attributiOk.HasValore;
                att.DescrizioneValore = attributiOk.DescrizioneValore;
                Categoria.Attributi.Add(att);
            }
            return result;
        }

        public void Rollback()
        {
            this.DSLavorazioni = (DataSetLavorazioni)this.DSLavorazioniRollback;
        }

        #endregion

        public void Salva(tipiLavorazione TipoLav)
        {
            this.DSLavorazioniRollback = (DataSetLavorazioni)this.DSLavorazioni.Copy();

            switch (TipoLav)
            {
                case tipiLavorazione.RinnovoContratto:
                case tipiLavorazione.FatturaInsoluta:
                    LavorazioniPraticheTableAdapter TaLavPra = new LavorazioniPraticheTableAdapter();
                    LavorazioneAttributiTableAdapter TALavAttr = new LavorazioneAttributiTableAdapter();
                    try
                    {
                        TaLavPra.Update(DSLavorazioni.LavorazioniPratiche);
                        DataSetLavorazioni.LavorazioniPraticheRow lavPraticaRow = this.DRLavorazioniPratiche;
                        foreach (DataSetLavorazioni.LavorazioneAttributiRow row in DSLavorazioni.LavorazioneAttributi.Rows)
                        {
                            row.LavorazionePratica = lavPraticaRow.idLavorazionePratica;
                        }
                        TALavAttr.Update(DSLavorazioni.LavorazioneAttributi);

                    }
                    catch (Exception e)
                    {
                        throw e;
                    }
                    finally
                    {
                        TaLavPra.Dispose();
                        TALavAttr.Dispose();
                    }
                    break;
                default:
                    break;
            }
        }
    }
}
