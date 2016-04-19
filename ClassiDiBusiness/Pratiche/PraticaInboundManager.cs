using ClassiDiBusiness.DAL;
//using ClassiDiBusiness.DAL.DataSetPraticheInboundTableAdapters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClassiDiBusiness.Pratiche
{
    [System.Serializable]
    public class PraticaInboundManager
    {
        #region variabili
        public LavorazionePraticaManager lManager;

        public DataSetPraticheInbound DSPraticheInbound;
        public DataSetPraticheInbound DSPraticheInboundRollback;

        tipiLavorazione? TipoLavorazione = null;
        private int idPratica;

        [NonSerialized]
        private DataManager DM;
        #endregion

        #region Costruttori
        public PraticaInboundManager()
        {

        }

        public PraticaInboundManager(int idPratica, tipiLavorazione tipoLav, DataManager DMOggetto)
        {
            this.DM = DMOggetto;
            this.TipoLavorazione = tipoLav;
            DSPraticheInbound = new DataSetPraticheInbound();
            switch (tipoLav)
            {
                case tipiLavorazione.VodafoneCVP:
                    /*Per questo tipo di lavorazione (INBOUND) le pratiche non sono caricate da import ma vengono generate al momento della lavorazione
                     * in questo caso inserisco una nuova riga nella tabella PraticaInbound (e la relativa generalizzazione). la riga la inserisco in fase di salvataggio, 
                     * inizializzo il dataset child con il valore chiave di -1, poi reso persistente il dato e recuperato l'id sostituisco il valore -1 
                     * col valore generato per la chiave chiave
                     */
                    //DSPraticheInbound = new DataSetPraticheInbound();
                    lManager = new LavorazionePraticaManager(idPratica, tipoLav, DMOggetto);
                    break;
                case tipiLavorazione.DelinquencyStorniTecnici:
                    break;
                case tipiLavorazione.VodafoneCaringOverLimit:
                    lManager = new LavorazionePraticaManager(idPratica, tipoLav, DMOggetto);
                    break;
                default:
                    break;
            }
        }

        public PraticaInboundManager(tipiLavorazione tipoLav, DataManager DMOggetto) : this(-1, tipoLav, DMOggetto)
        {
        }

        public void Inizializza(DataManager DMOggetto)
        {
            this.DM = DMOggetto;
            if (DSPraticheInbound == null) DSPraticheInbound = new DataSetPraticheInbound();
            //if (TipoLavorazione == null)
            //{
            //    if (aManager == null) aManager = new AzioniManager();
            //    if (sManager == null) sManager = new ScadenzaManager();
            //}
            //else
            //{
            switch (TipoLavorazione)
            {
                case tipiLavorazione.VodafoneCVP:
                    if (lManager == null) lManager = new LavorazionePraticaManager();
                    break;
                default:
                    break;
            }
            //}
        }
        #endregion

        #region Gestione Dati
        public void Rollback(DataManager DMOggetto)
        {
            this.DSPraticheInbound = (DataSetPraticheInbound)this.DSPraticheInboundRollback;
        }

        public void InserisciNuovaRigaVodafoneCVP(DataSetPraticheInbound.VodafoneCVPRow dr)
        {
            DSPraticheInbound.VodafoneCVP.AddVodafoneCVPRow(dr);
        }

        public void InserisciNuovaRigaStorniTecniciDelinquency(DataSetPraticheInbound.StorniTecniciDelinquencyRow dr)
        {
            DSPraticheInbound.StorniTecniciDelinquency.AddStorniTecniciDelinquencyRow(dr);
        }

        public void InserisciNuovaRigaPraticaInbound(DataSetPraticheInbound.PraticheInboundRow dr)
        {
            DSPraticheInbound.PraticheInbound.AddPraticheInboundRow(dr);
        }

        public DataSetPraticheInbound.VodafoneCVPRow rowVodafoneCvp
        {
            get { return this.DSPraticheInbound.VodafoneCVP[0]; }
        }

        public DataSetPraticheInbound.StorniTecniciDelinquencyRow rowStorniTecniciDelinquency
        {
            get { return this.DSPraticheInbound.StorniTecniciDelinquency[0]; }
        }

        public DataSetPraticheInbound.PraticheInboundRow rowPraticheInbound
        {
            get { return this.DSPraticheInbound.PraticheInbound[0]; }
        }

        public int salvaPraticaInbound(DataManager DMOggetto)
        {
            bool transazioneInterna = false; // Gestisce sia una transazione interna che una passata dall'esterno

            if (DMOggetto.GetTransazione == null)
            {
                transazioneInterna = true;
                DMOggetto.BeginTrans();
            }

            PraticheInboundTableAdapter TAPraticheInbound = new PraticheInboundTableAdapter(DMOggetto);
            try
            {
                TAPraticheInbound.Update(this.DSPraticheInbound);

                if (transazioneInterna)
                {
                    DMOggetto.CommitTrans();
                }
                return this.rowPraticheInbound.id;
            }
            catch (Exception e)
            {
                if (transazioneInterna) DMOggetto.RollbackTrans();
                this.Rollback(DMOggetto);
                ClassiBase.Services.Logger.Scrivi("PraticaManager.SalvaPraticheInbound", ClassiBase.Services.Logger.Gravita.ErroreDiProgramma, e);
                throw;
            }
            finally
            {
                TAPraticheInbound.Dispose();
            }
        }

        public void SalvaLavorazione(DataManager DMOggetto, tipiLavorazione tipoLav)
        {
            bool transazioneInterna = false; // Gestisce sia una transazione interna che una passata dall'esterno

            if (DMOggetto.GetTransazione == null)
            {
                transazioneInterna = true;
                DMOggetto.BeginTrans();
            }
                        
            int idPraticaInbound;
            
            if (this.DSPraticheInbound.HasChanges())//this.rowPraticheInbound.id <= 0)
                idPraticaInbound = salvaPraticaInbound(DMOggetto);
            else
                idPraticaInbound = this.rowPraticheInbound.id;
            switch (tipoLav)
            {
                case tipiLavorazione.VodafoneCVP:                    
                    VodafoneCVPTableAdapter TAVodCvp = new VodafoneCVPTableAdapter(DMOggetto);
                    try
                    {                        
                        this.rowVodafoneCvp.idPraticaInbound = this.rowPraticheInbound.id;
                        TAVodCvp.Update(this.rowVodafoneCvp);
                        if (transazioneInterna)
                        {
                            DMOggetto.CommitTrans();
                        }
                    }
                    catch (Exception e)
                    {
                        if (transazioneInterna) DMOggetto.RollbackTrans();
                        this.Rollback(DMOggetto);
                        ClassiBase.Services.Logger.Scrivi("PraticaManager.SalvaVodafoneCVP", ClassiBase.Services.Logger.Gravita.ErroreDiProgramma, e);
                        throw;
                    }
                    finally
                    {                        
                        TAVodCvp.Dispose();
                    }

                    break;
                case tipiLavorazione.DelinquencyStorniTecnici:
                    StorniTecniciDelinquencyTableAdapter TAStorni = new StorniTecniciDelinquencyTableAdapter(DMOggetto);
                    try
                    {
                        this.rowStorniTecniciDelinquency.idPraticaInbound = this.rowPraticheInbound.id;
                        TAStorni.Update(this.rowStorniTecniciDelinquency);
                        if (transazioneInterna)
                        {
                            DMOggetto.CommitTrans();
                        }
                    }
                    catch (Exception e)
                    {
                        if (transazioneInterna) DMOggetto.RollbackTrans();
                        this.Rollback(DMOggetto);
                        ClassiBase.Services.Logger.Scrivi("PraticaManager.SalvaDelinquencyStorniTecnici", ClassiBase.Services.Logger.Gravita.ErroreDiProgramma, e);
                        throw;
                    }
                    finally
                    {
                        TAStorni.Dispose();
                    }
                    break;
                default:
                    break;
            }
        }
        #endregion
    }
}
