<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Pratica.aspx.cs" Inherits="LamaVetWeb.Pratiche.Pratica" %>

<%@ Register Src="~/LavorazionePratica/AttributiLavorazionePraticaWUC.ascx" TagPrefix="uc1" TagName="AttributiLavorazionePraticaWUC" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lavorazione Pratica</title>
    <link rel="stylesheet" href="/jquery-ui/jquery-ui.min.css" />
    <link href="../css/LavorazionePratica.css" rel="stylesheet" />
    <style>
        body {
            font: "Trebuchet MS", sans-serif;
            font-size: small;
            margin: 20px;
        }

        .separatore {
            clear: both;
            padding-top: 5px;
            padding-bottom: 5px;
        }

        .divisore {
            margin: 0 10px 10px 0;
            float: left;
        }

        .bottone {
            font-size: small;
        }

        .ContenitoreLavAttr {
            width: 900px;
            margin: auto;
        }

        .LabelCampiDiv {
            width: 49%;
            float: left;
            font-weight: bold;
        }

        .ValoreCampiDiv {
            width: 50%;
            float: left;
        }

        .demoHeaders {
            margin-top: 2em;
        }

        #dialog-link {
            padding: .4em 1em .4em 20px;
            text-decoration: none;
            position: relative;
        }

            #dialog-link span.ui-icon {
                margin: 0 5px 0 0;
                position: absolute;
                left: .2em;
                top: 50%;
                margin-top: -8px;
            }

        #icons {
            margin: 0;
            padding: 0;
        }

            #icons li {
                margin: 2px;
                position: relative;
                padding: 4px 0;
                cursor: pointer;
                float: left;
                list-style: none;
            }

            #icons span.ui-icon {
                float: left;
                margin: 0 4px;
            }

        .fakewindowcontain .ui-widget-overlay {
            position: absolute;
        }

        select {
            width: 200px;
        }

        .anagAlfan {
        }

        .container {
            position: relative;
            background: gray;
            padding: 30px;
            overflow: hidden;
        }

            .container:before, .container:after {
                position: absolute;
                content: '';
                background: red;
                display: block;
                width: 100%;
                height: 15px;
                -webkit-transform: rotate(-45deg);
                transform: rotate(-45deg);
                left: 0;
                right: 0;
                top: 0;
                bottom: 0;
                margin: auto;
            }

            .container:after {
                -webkit-transform: rotate(45deg);
                transform: rotate(45deg);
            }
    </style>
    <script src="/jquery-ui/external/jquery/jquery.js"></script>
    <script src="/jquery-ui/jquery-ui.min.js"></script>
    <script src="/jquery-ui/jquery.ui.touch-punch.min.js"></script>
</head>
<body>
    <script type="text/javascript">

        var AttributiRinnovo = {
            CambiatoIndirizzo: 1
        }

        var CategorieFattura = {
            Contatti: 6,
            RecuperoCrediti: 9
        }

        var AttributiFattura = {
            InvioCartaceo: 14,
            FatturaNonRicavuta: 13,
            Pagato: 17,
            Paghera: 18,
            NonPaghera: 19
        }

        $(document).ready(function () {
            $(".bottone").button();

            // Add an event listener
            $(document).on("AttributoSelezionatoDropped", function (e, data) {
                AttributoSelezionatoHandler(data.idAttributo, data.ValoreAttributo);
            });
            $(document).on("AttributoEliminatoDropOut", function (e, data) {
                AttributoEliminatoHandler(data.idAttributo);
            });

            if ($('#ddlTipoLav').val() == 2) {
                AggiungiCategoriaEsclusa(CategorieFattura.Contatti);
                AggiungiCategoriaEsclusa(CategorieFattura.RecuperoCrediti);
            }
        });

        function AttributoSelezionatoHandler(idAttributo, valoreAttributo) {
            if (idAttributo == AttributiRinnovo.CambiatoIndirizzo || idAttributo == AttributiFattura.InvioCartaceo) {
                $('#NuonaAnagraficaDiv').show();
            }
            if (idAttributo == AttributiFattura.FatturaNonRicavuta) {
                RimuoviCategoriaEsclusa(CategorieFattura.Contatti);
            }
            if (idAttributo == AttributiFattura.NonPaghera) {
                RimuoviCategoriaEsclusa(CategorieFattura.RecuperoCrediti);
            }
        }

        function AttributoEliminatoHandler(idAttributo) {
            if (idAttributo == AttributiRinnovo.CambiatoIndirizzo || idAttributo == AttributiFattura.InvioCartaceo) {
                PulisciAnagrafica();
                $('#NuonaAnagraficaDiv').hide();
            }
            if (idAttributo == AttributiFattura.FatturaNonRicavuta) {
                AggiungiCategoriaEsclusa(CategorieFattura.Contatti);
            }
            if (idAttributo == AttributiFattura.NonPaghera) {
                AggiungiCategoriaEsclusa(CategorieFattura.RecuperoCrediti);
            }
        }

        function PulisciAnagrafica() {
            $('.anagAlfan').val('');
        }
        function PulisciNote() {
            $('#taNote').val('');
        }
        function PulisciOsservazioni() {
            $('#taOsservazioni').val('')
        }

        function PulisciForm() {
            PulisciAnagrafica();
            PulisciNote();
            PulisciOsservazioni();
        }
    </script>
    <form id="form1" runat="server">
        <div>
            <div>
                <center>
                    <h1 style="color: rgb(0,56,126);">LAVORAZIONE DELLA PRATICA</h1>
                </center>
            </div>
            <div>
                <h3 class="titolo ui-corner-top">TIPO DI LAVORAZIONE</h3>
                <div class="separatore"></div>
                <div style="float: left">
                    <asp:DropDownList ID="ddlTipoLav" runat="server">
                        <asp:ListItem Value="2">Fattura insoluta</asp:ListItem>
                        <asp:ListItem Value="1">Rinnovo contratto</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="divisore"></div>
                <div style="float: left">
                    <asp:Button ID="btnCambiaLav" runat="server" Text="Cambia lavorazione" CssClass="bottone" OnClientClick="PulisciForm()" OnClick="btnCambiaLav_Click" />
                </div>
                <div style="float: right; margin-right: 15px;">
                    <img src="../images/Punto-interrogativo.gif" style="height: 32px; width: 32px; cursor: pointer;" onclick="window.open('https://github.com/cervelliriccardo/LavorazionePratica','mywindow');" />
                </div>
            </div>
            <div class="separatore"></div>
            <div>
                <div style="float: left; width: 30%;">
                    <h3 class="titolo ui-corner-top">DATI PRATICA INPUT</h3>
                    <div>
                        <div class="separatore"></div>
                        <div class="LabelCampiDiv">Numero Pratica</div>
                        <div class="ValoreCampiDiv">1111111111</div>
                        <div class="separatore"></div>
                        <div class="LabelCampiDiv">Topo contratto</div>
                        <div class="ValoreCampiDiv">Business</div>
                        <div class="separatore"></div>
                        <div class="LabelCampiDiv">Nome</div>
                        <div class="ValoreCampiDiv">Maio</div>
                        <div class="separatore"></div>
                        <div class="LabelCampiDiv">Cognome</div>
                        <div class="ValoreCampiDiv">Rossi</div>
                        <div class="separatore"></div>
                        <div class="LabelCampiDiv">Cellulare</div>
                        <div class="ValoreCampiDiv">333 444 55 66</div>
                        <div class="separatore"></div>
                        <div class="LabelCampiDiv">Email</div>
                        <div class="ValoreCampiDiv">posta@email.it</div>
                        <div class="separatore"></div>
                        <div class="LabelCampiDiv">Indirizzo</div>
                        <div class="ValoreCampiDiv">Via Roma 55</div>
                        <div class="LabelCampiDiv">Comune</div>
                        <div class="ValoreCampiDiv">Roma</div>
                        <div class="LabelCampiDiv">Provincia</div>
                        <div class="ValoreCampiDiv">Rm</div>
                        <div class="LabelCampiDiv">Cap</div>
                        <div class="ValoreCampiDiv">00000</div>
                        <div class="separatore"></div>
                    </div>
                    <asp:Panel ID="pnlEliminati" runat="server" Enabled="false" CssClass="container">
                        <div>
                            Cambiato indirizzo                 
                            <input id="Checkbox1" type="checkbox" />
                        </div>
                        <div>
                            Cambiato telefono                  
                            <input id="Checkbox2" type="checkbox" />
                        </div>
                        <div>
                            Cambiata email                     
                            <input id="Checkbox3" type="checkbox" />
                        </div>
                        <div>
                            Rinnova                            
                            <input id="Checkbox4" type="checkbox" />
                        </div>
                        <div>
                            Non rinnova                        
                            <input id="Checkbox5" type="checkbox" />
                        </div>
                        <div>
                            Richiede sconto                    
                            <input id="Checkbox6" type="checkbox" />
                        </div>
                        <div>
                            Chiarezza fattura                  
                            <input id="Checkbox7" type="checkbox" />
                        </div>
                        <div>
                            Qualità del servizio               
                            <input id="Checkbox8" type="checkbox" />
                        </div>
                        <div>
                            Tempi di attesa call center        
                            <input id="Checkbox9" type="checkbox" />
                        </div>
                        <div>
                            Consapevole                        
                            <input id="Checkbox10" type="checkbox" />
                        </div>
                        <div>
                            Inconsapevole                      
                            <input id="Checkbox11" type="checkbox" />
                        </div>
                        <div>
                            Fattura ricevuta                   
                            <input id="Checkbox12" type="checkbox" />
                        </div>
                        <div>
                            Fattura non ricevuta               
                            <input id="Checkbox13" type="checkbox" />
                        </div>
                        <div>
                            Invio cartaceo                     
                            <input id="Checkbox14" type="checkbox" />
                        </div>
                        <div>
                            Invio email                        
                            <input id="Checkbox15" type="checkbox" />
                        </div>
                        <div>
                            Invio sms emissione                
                            <input id="Checkbox16" type="checkbox" />
                        </div>
                        <div>
                            Pagata                             
                            <input id="Checkbox17" type="checkbox" />
                        </div>
                        <div>
                            Pagherà                            
                            <input id="Checkbox18" type="checkbox" />
                        </div>
                        <div>
                            Non pagherà                        
                            <input id="Checkbox19" type="checkbox" />
                        </div>
                        <div>
                            Insoddisfatto servizio             
                            <input id="Checkbox20" type="checkbox" />
                        </div>
                        <div>
                            Richiede sconto                    
                            <input id="Checkbox21" type="checkbox" />
                        </div>
                        <div>
                            Rescinde contratto                 
                            <input id="Checkbox22" type="checkbox" />
                        </div>
                        <div>
                            Invio a recupero crediti           
                            <input id="Checkbox23" type="checkbox" />
                        </div>
                        <div>
                            Invio a legale                     
                            <input id="Checkbox24" type="checkbox" />
                        </div>
                    </asp:Panel>
                </div>
                <div style="float: right; width: 69%;">
                    <h3 class="titolo ui-corner-top">DATI LAVORAZIONE PRATICA</h3>
                    <div>
                        <div>Osservazioni del cliente:</div>
                        <div>
                            <textarea id="taOsservazioni" cols="20" rows="2" style="width: 100%; height: 100px;"></textarea>
                        </div>
                    </div>
                    <div id="NuonaAnagraficaDiv" runat="server" style="display: none">
                        <div>
                            <div>
                                <div style="clear: both; padding-top: 5px; padding-bottom: 5px;">
                                    <div style="float: left; padding-left: 2px; padding-right: 2px;">
                                        Indirizzo e Civico
                                <asp:TextBox ID="tbIndAnag" CssClass="anagAlfan" runat="server" Width="530px"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="clear: both; padding-top: 5px; padding-bottom: 5px;">
                                    <div style="float: left; padding-left: 2px; padding-right: 2px;">
                                        Provincia
                            <asp:TextBox ID="tbProvinciaAnag" runat="server" CssClass="anagAlfan" Width="300px"></asp:TextBox>
                                    </div>
                                    <div style="float: right; padding-left: 2px; padding-right: 2px;">
                                        Comune
                            <asp:TextBox ID="tbComuneAnag" runat="server" CssClass="anagAlfan" Width="210px"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="clear: both; padding-top: 5px; padding-bottom: 5px;">
                                    <div style="float: left; padding-left: 2px; padding-right: 2px;">
                                        cap
                            <asp:TextBox ID="tbCapAnag" runat="server" CssClass="anagAlfan"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="separatore"></div>
                    <div>
                        <div>Note:</div>
                        <div>
                            <textarea id="taNote" cols="20" rows="2" style="width: 100%; height: 100px;"></textarea>
                        </div>
                    </div>
                    <div class="separatore"></div>
                    <div class="ContenitoreLavAttr">
                        <h3 class="titolo ui-corner-top">Attributi LAVORAZIONE PRATICA</h3>
                        <uc1:AttributiLavorazionePraticaWUC runat="server" ID="AttributiLavorazionePraticaWUC" idTipoLavorazione="1" />
                    </div>
                </div>
            </div>
            <div class="separatore"></div>
            <div class="separatore"></div>
            <div>
                <center>
                    <asp:Button ID="btnPulisciLav" runat="server" Text="Reset" CssClass="bottone" OnClientClick="PulisciForm()" OnClick="btnCambiaLav_Click" />
                </center>
            </div>
            <div class="separatore"></div>
            <div class="separatore"></div>
            <div>
                <center>
                    <script src="//platform.linkedin.com/in.js" type="text/javascript"></script>
<script type="IN/MemberProfile" data-id="https://www.linkedin.com/pub/riccardo-cervelli/12/268/619" data-format="hover" data-text="Riccardo Cervelli"></script>
                </center>
            </div>
        </div>
    </form>
</body>
</html>
