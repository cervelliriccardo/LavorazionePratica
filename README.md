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
