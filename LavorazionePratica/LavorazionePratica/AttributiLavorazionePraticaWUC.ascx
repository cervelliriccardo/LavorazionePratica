<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AttributiLavorazionePraticaWUC.ascx.cs" Inherits="LamaVetWeb.Pratiche.LavorazionePratica.AttributiLavorazionePraticaWUC" %>
<meta charset="utf-8">
<%@ Import Namespace="ClassiDiBusiness.Pratiche" %>
<%@ Import Namespace="System.Data" %>

<%-- 
    Il controllo mette a disposizione dei servizi javascript sotto forma di funzioni richiamabili al di fuori del WUC:
    handleDropEvent: Scatena un evento al momento del drop di selezione di un attributo. Una pagina che incapsula il WUC si può registrare all'evento e gestirlo.
    handleDropOutEvent: Scatena un evento al momento del drop out di un attributo(Attributo gettato nel cestino). Una pagina che incapsula il WUC si può registrare all'evento e gestirlo.
    AggiungiCategoriaEsclusa: Chiamando questa funzione si può eliminare una categoria dalla liste degli Attributi selezionabili.
    RimuoviCategoriaEsclusa: Chiamando questa funzione si può reinserire una categoria, precedentemente eliminata, dalla liste degli Attributi selezionabili.
    ClearCategorieEscluse: Chiamando questa funzione si può ripulire la lista delle categorie precedentemente eliminate, rendendole di nuovo tutte disponibili.
    AggiungiAttributoEscluso: Chiamando questa funzione si può eliminare un attributo dalla liste degli Attributi selezionabili.
    RimuoviAttributoEscluso: Chiamando questa funzione si può reinserire un attributo, precedentemente eliminato, dalla liste degli Attributi selezionabili.
    ClearAttributiEsclusi: Chiamando questa funzione si può ripulire la lista degli Attributi precedentemente eliminati, rendendoli di nuovo tutti disponibili.
--%>

<style>
    h1 {
        padding: .2em;
        margin: 0;
    }

    .LavElement {
        float: left;
        min-width: 300px;
        max-width: 350px;
        margin-right: 2em;
    }

    .ulCursorClass li:hover {
        cursor: -webkit-grab;
    }

    #cart {
        float: left;
    }
        /* style the list to maximize the droppable hitarea */
        #cart ul {
            margin: 0;
            padding: 1em 0 1em 3em;
        }
</style>
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

        var AttributiSelezionati = jSonRes.AttributiLavorazione.AttributiSelezionati;
        $("#attrSelezionatiDiv").empty();
        $("#attrSelezionatiDiv").append("<ul id='ulAttrSel' class='droppable ulCursorClass'>");
        $.each(AttributiSelezionati, function (idxAttrSel, objAttrSel) {
            $("#ulAttrSel").append("<li class='draggable AttrSel' id='liAttributoSel" + idxAttrSel + "' idattributo='" + objAttrSel.idAttributo + "'>" + objAttrSel.Descrizione + "</li>");
        });
        inizializza();
    }
</script>
<asp:HiddenField ID="hidAccordionIndex" runat="server" Value="0" ClientIDMode="Static" />
<asp:HiddenField ID="hfIdAttrSel" runat="server" ClientIDMode="Static" />
<input id="hfidlManager" type="hidden" runat="server" clientidmode="Static" />
<div class="LavElement" id="products">
    <h3 class="titolo ui-corner-top">Attributi</h3>
    <div id="CategorieTendinaConteiner">
        <div id="catalog">
        </div>
    </div>
</div>
<div>
</div>
<div class="LavElement" id="cart" style="margin-left: 80px;">
    <h3 class="titolo ui-corner-top">Attributi LAVORAZIONE</h3>
    <div id="attrSelezionatiDiv" class="ui-widget-content" style="float: left; width: 99%;">
    </div>
</div>
<div style="margin-top: 10px;">
    <div id="LAVTrash" class="ui-widget-content" style="border-style: none; border-color: inherit; border-width: medium; float: right; overflow: hidden;">
        <asp:Image ID="imgTrash" runat="server" ImageUrl="~/images/Empty_Trash.png" Height="90px" Width="90px" />
    </div>
</div>
<div id="PnlAddAttributo" style="display: none" title="Inserisci valore Attributo">
    <div>
        Attributo:&nbsp;&nbsp;
        <asp:Label ID="LAVAttributoLavorazioneSel" Font-Bold="true" ClientIDMode="Static" runat="server" Text=""></asp:Label><br />
        <div style="">
            Valore attributo:
            <asp:TextBox ID="tbValoreAttributo" ClientIDMode="Static" runat="server" MaxLength="100" Width="100"></asp:TextBox>
        </div>
        <br />
        <div>
            <asp:Button ID="btnSalvaAddAttr" Visible="false" runat="server" Text="Salva" />
        </div>
        <div style="display: none;">
            <asp:Button ID="btnDropOut" Visible="false" runat="server" Text="Button" />
        </div>
    </div>
</div>
