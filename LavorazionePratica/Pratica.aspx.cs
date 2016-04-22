using ClassiDiBusiness.Pratiche;
using System;

namespace LamaVetWeb.Pratiche
{
    
    public partial class Pratica : System.Web.UI.Page
    {
        public LavorazionePraticaManager lmanager;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
             
            }
            if (Session["lManager"] == null)
                lmanager = new LavorazionePraticaManager(-1, tipiLavorazione.FatturaInsoluta);
            inizializzaWuc(lmanager, true);
        }

        private void refreshLavorazione(tipiLavorazione tipoLav)
        {
            Session.Remove("lManager");
            lmanager = null;
            lmanager = new LavorazionePraticaManager(-1, tipoLav);
            inizializzaWuc(lmanager, true);
        }

        private void inizializzaWuc(LavorazionePraticaManager laManager, bool saveCache = true)
        {
            AttributiLavorazionePraticaWUC.Inizializza(laManager, saveCache);
        }

        protected void btnCambiaLav_Click(object sender, EventArgs e)
        {
            tipiLavorazione tipoLavSel = (tipiLavorazione)Enum.Parse(typeof(tipiLavorazione), ddlTipoLav.SelectedValue);
            refreshLavorazione(tipoLavSel);
        }
    }
}