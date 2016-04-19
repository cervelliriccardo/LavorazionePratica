# Attributi di lavorazione di una pratica
Nell'ufficio software dell’azienda per la quale lavoro, realizziamo il gestionale con cui l’area operativa gestisce il proprio business. I nostri clienti ci affidano pratiche da lavorare attraverso il call canter. Il frutto di queste lavorazioni porta all’acquisizione di informazioni che saranno poi riportate ai clienti.

Ho potuto subito verificare che la quantità di informazioni di interesse dei clienti era in continua evoluzione, spesso ci veniva richiesto di aggiungere un’informazione binaria, ovvero una domanda alla quale si poteva rispondere “si” o “no”, oppure informazioni descrittive di piccola entità.

In questo scenario si presentava il problema della gestione di queste informazioni. Inizialmente venivano salvate in una tabella che raccoglieva buona parte dei dati ricevuti in input e tutte le informazioni recuperate durante la lavorazione, da restituire come output. 
La tabella era molto eterogenea, ci venivano registrate informazioni di attività diverse quindi, a seconda della lavorazione richiesta, molte colonne rimanevano inutilizzate.

Un altro motivo di inefficienza era dato dal fatto che ad ogni richiesta di aggiungere un’informazione, anche di tipo “flag”, si doveva aggiungere una colonna nella suddetta tabella, con il risultato di avere una crescita “incontrollata” della struttura e un’impegno cospicuo nella modifica del software per gestire una colonna in più ad ogni aggiunta.

Per risolvere questi problemi ho pensato di trasformare il salvataggio di queste informazioni da una struttura di tipo orizzontale a verticale. Ho introdotto nella base dati una struttura a fiocco di neve grazie alla quale ogni informazione richiesta viene considerata come un attributo applicato o non applicato alla lavorazione di una pratica.

#DataBase
Lo schema della base dati è composto da una tabella in cui vengono definiti gli attributi, una tabella che raggruppa gli attributi per categoria, i tipi di lavorazione e quali categorie di attributi ne fanno parte, la configurazione delle esclusioni fra categorie e delle esclusioni fra attributi, ed in fine, le lavorazioni vere e proprie associate alle pratiche.  
Lo schema è mostrato in seguito:  
  
  
![Database Schema](https://github.com/cervelliriccardo/LavorazionePratica/blob/master/SchemaDBAttributiLavorazione.png)

#Risultati
La struttura è dinamica e ampiamente configurabile. 
Si definiscono i vari tipi di lavorazione, per ogni lavorazione si stabiliscono gli attributi disponibili. Gli attributi fanno parte di contenitori chiamati “Categorie”
Si possono stabilire delle propedeuticità e delle esclusioni fra categorie e fra attributi. Selezionando per esempio l’attributo “Fattura pagata” della categoria “Pagamento” non ha senso avere disponibili gli attributi della categoria “Recupero crediti” quindi l’intera categoria verrà nascosta.
Un altro caso è l’esclusione di un attributo incompatibile con un altro. Per esempio all’interno della categoria “Pagamento” se viene selezionato l’attributo “Pagata” scompariranno gli attributi “Pagherà” e “Non pagherà”  e vice versa.

Con questa soluzione, per soddisfare la richiesta di aggiungere un’informazione da censire durante la lavorazione di una pratica, basterà configurare nel sistema poche tabelle tipologiche e di configurazione. Il nuovo attributo sarà immediatamente disponibile.

Una demo è visibile all’indirizzo:
[Lavorazione di una pratica](http://www.lamacom.it/pratiche/pratica.aspx)

#Codice
Il lavoro principale è fatto dal Web User Control, contenuto nella pagina web che mostra il funzionamento, e dalla trapdoor chiamata dal WUC. Il controllo funziona interamente in jQuery. Richiama funzionalità esposte dalla TrapDoor per aggiungere od eliminare gli attributi selezionati. In base alla selezione effettuata la TrapDoor restituisce la liste degli attributi validi rispetto alle configurazioni di esclusione impostate a sistema.

##AttributiLavorazionePraticaWUC
```javascript
<script>
    $(document).ready(function () {
        SendRequesLavorazioni("Inizializza", $("#hfidlManager").val(), null, null);
    });

    function inizializza() {

        var activeIndex = parseInt($("#hidAccordionIndex").val());

        $("#catalog").accordion({
            autoHeight: false,
            event: "mousedown",
            active: activeIndex,
            collapsible: true,
            activate: function (event, ui) {
                var index = $(this).accordion("option", "active");
                $("#hidAccordionIndex").val(index);
            }
        });

        $(".draggable").draggable({
            helper: "clone",
            cursor: "-webkit-grabbing",
            revert: "invalid"
        });

        //se non ritardiamo di pochi millisecondi la funzione drop parte prima della funzione stop del grag e elimina l'elemento spostato generando un errore.
        $(".droppable").droppable({
            drop: function (event, ui) {
                window.setTimeout(function () {
                    handleDropEvent(event, ui);
                }, 10);
            }
        });

        //se non ritardiamo di pochi millisecondi la funzione drop parte prima della funzione stop del grag e elimina l'elemento spostato generando un errore.
        $("#LAVTrash").droppable({
            accept: '.AttrSel',
            tolerance: 'touch',
            drop: function (event, ui) {
                window.setTimeout(function () {
                    handleDropOutEvent(event, ui);
                }, 10);
            }
        });

        $("#PnlAddAttributo").dialog({
            autoOpen: false,
            width: 375,
            height: 175,
            modal: true,
            resizable: false,
            closeOnEscape: false,
            open: function (event, ui) {
                $(".ui-dialog-titlebar-close").hide();
            },
            buttons: {
                Salva: function () {
                    SendRequesLavorazioni("AggiungiAttributo", $("#hfidlManager").val(), $("#hfIdAttrSel").val(), $("#tbValoreAttributo").val());
                    $.event.trigger('AttributoSelezionatoDropped', [{ idAttributo: $("#hfIdAttrSel").val(), ValoreAttributo: $("#tbValoreAttributo").val() }]);
                    $("#tbValoreAttributo").val("");
                    $(this).dialog("close");
                },
                Annulla: function () {
                    $(this).dialog("close");
                    return false;
                }
            }
        });
    }

    function handleDropEvent(event, ui) {
        $("#hfIdAttrSel").val(ui.draggable.attr('idAttributo'));
        //se l'attributo ha un valore apro la finestra per l'immissione del valore e demando la send alla finestra
        if (ui.draggable.attr('hasvalue') == 'true') {
            $("#LAVAttributoLavorazioneSel").html(ui.draggable.attr('descrizioneValore'));
            $("#PnlAddAttributo").dialog("open");
        }
        else {
            SendRequesLavorazioni("AggiungiAttributo", $("#hfidlManager").val(), $("#hfIdAttrSel").val(), null);
            $.event.trigger('AttributoSelezionatoDropped', [{ idAttributo: $("#hfIdAttrSel").val(), ValoreAttributo: null }]);
        }
    }

    function handleDropOutEvent(event, ui) {
        SendRequesLavorazioni("EliminaAttributo", $("#hfidlManager").val(), ui.draggable.attr('idAttributo'), null);
        $.event.trigger('AttributoEliminatoDropOut', [{ idAttributo: ui.draggable.attr('idAttributo') }]);
    }

    function AggiungiCategoriaEsclusa(idCategoria) {
        SendRequesLavorazioni("AggiungiCategoriaEsclusa", $("#hfidlManager").val(), idCategoria, null);
    }

    function RimuoviCategoriaEsclusa(idCategoria) {
        SendRequesLavorazioni("RimuoviCategoriaEsclusa", $("#hfidlManager").val(), idCategoria, null);
    }

    function ClearCategorieEscluse() {
        SendRequesLavorazioni("ClearCategorieEscluse", $("#hfidlManager").val(), null, null);
    }

    function AggiungiAttributoEscluso(idAttributo) {
        SendRequesLavorazioni("AggiungiAttributoEscluso", $("#hfidlManager").val(), idAttributo, null);
    }

    function RimuoviAttributoEscluso(idAttributo) {
        SendRequesLavorazioni("RimuoviAttributoEscluso", $("#hfidlManager").val(), idAttributo, null);
    }

    function ClearAttributiEsclusi() {
        SendRequesLavorazioni("ClearAttributiEsclusi", $("#hfidlManager").val(), null, null);
    }

    function SendRequesLavorazioni(operazione, idlManager, idAttributo, ValoreAttributo) {
        var options = {
            error: function (msg) {
                App.alert({ type: 'danger', icon: 'warning', message: msg.d, place: 'append', closeInSeconds: 5 });
            },
            type: "POST",
            url: "/TrapDoor/LavorazioniPratica/LavorazioniPraticaHandler.ashx",
            data: "idlManager=" + idlManager + "&Operazione=" + operazione + "&idAttributo=" + idAttributo + "&ValoreAttributo=" + ValoreAttributo,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {
                bindAttributi(response);
            }
        };
        jQuery.ajax(options);
    }

    function f_controllaAbilitazLAVPratica() {
        return $('#hfIdAttrSel').val() != "";
    }

    function bindAttributi(jSonRes) {
        $("#hfidlManager").val(jSonRes.idlManager);
        var categorie = jSonRes.AttributiValidi.CategorieAttributi;
        $("#CategorieTendinaConteiner").empty();
        $("#CategorieTendinaConteiner").append("<div id='catalog'>");
        $.each(categorie, function (idx, obj) {
            $("#catalog").append("<h2><a href='#'>" + obj.Descrizione + "</a></h2>");
            $("#catalog").append("<div id='divCatAcc" + idx + "' style='overflow: hidden; position: initial;'>");
            $("#divCatAcc" + idx).append("<ul id='ulAttr" + idx + "' class='ulCursorClass' >");
            $.each(obj.Attributi, function (idxAttr, objAttr) {
                $("#ulAttr" + idx).append("<li class='draggable' z-index='10' id='liAttributo" + idx + idxAttr + "' idAttributo='" + objAttr.idAttributo + "' hasvalue='" + objAttr.HasValore + "' descrizioneValore='" + objAttr.DescrizioneValore + "'>" + objAttr.Descrizione + "</li>");
            })
        });

        var attributiSelezionati = jSonRes.AttributiLavorazione.AttributiSelezionati;
        $("#attrSelezionatiDiv").empty();
        $("#attrSelezionatiDiv").append("<ul id='ulAttrSel' class='droppable ulCursorClass'>");
        $.each(attributiSelezionati, function (idxAttrSel, objAttrSel) {
            $("#ulAttrSel").append("<li class='draggable AttrSel' id='liAttributoSel" + idxAttrSel + "' idattributo='" + objAttrSel.idAttributo + "'>" + objAttrSel.Descrizione + "</li>");
        });
        inizializza();
    }
</script>
```
##TrapDoor
```csharp
public class LavorazioniPraticaHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    LavorazionePraticaManager lManager;

    private class jsonResult
    {
        public int idlManager { get; set; }
        public AttributiCategorie AttributiValidi { get; set; }
        public AttributiLavorazione AttributiLavorazione { get; set; }
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
                        //serve a caricare gli attributi eventualmente già selezionati nei round precedenti
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
                    case "ClearAttributiEsclusi":
                        ClearAttributiEsclusi();
                        break;
                    default:
                        break;
                }

                AttributiLavorazione AttributiLav = lManager.GetAttributiSelezionati();
                if (AttributiLav.AttributiSelezionati.Count <= 0)
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
                JsonResult.AttributiLavorazione = lManager.GetAttributiSelezionati();
                JsonResult.AttributiValidi = lManager.GetAttributiValidi();
                context.Response.Write(JsonConvert.SerializeObject(JsonResult));
            }
        }
        catch (Exception)
        {

            throw;
        }

    }
```
##LavorazionePraticaManager
```csharp
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
```
