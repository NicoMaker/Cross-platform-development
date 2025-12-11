# esame 1

SI RICORDA CHE SI PROGRAMMA **IN INGLESE**!
NON SI ACCETTANO SOLUZIONI CON CODICE IN ITALIANO.

## modalità d'esame

Di seguito, viene descritta nuovamente la modalità d'esame.

### consegna

Dovete consegnare la vostra repository contenente la soluzione, privatamente, usando Google Chat.

### divieti e permessi

Si ricorda che venir meno alle regole d'esame pubblico costituisce **reato** (l. 475/1925); in caso di violazione, è mia responsabilità segnalare l'accaduto all'ufficio o al responsabile competente.

In aggiunta a ciò, una qualsiasi violazione delle regole d'esame equivale a **fallimento immediato** dell'esame, con punteggio 0 (ZERO): **qualsiasi** mia decisione in questo senso è _inappellabile_.

È permesso l'uso di qualsiasi risorsa online (documentazione, forum, ecc.).
È permesso l'uso di IDE, editor di testo, compilatori, emulatori, simulatori, dispositivi fisici, ecc.
È permesso l'uso di qualsiasi libreria o pacchetto open source - a vostro rischio e pericolo!
È permesso l'uso di appunti personali.
È permesso fare domande di chiarimento, alzando la mano, con ordine.

Non è permesso l'uso di IA/LLM (Cursor, ChatGPT, Gemini, Copilot, ecc.) siano esse integrate o meno nell'IDE.
Non è permesso l'uso di "soluzioni preconfezionate" (ad esempio, soluzioni trovate online stile "Stack Overflow", o fornite da terzi).
Non è permesso l'uso di dispositivi esterni (smartphone, tablet, ecc.): usate solo il vostro laptop.
Non sono permessi scambi di informazioni o aiuti con altre persone in nessun modo (non importa quanto siete creativi).

## esercizio di programmazione in Dart

Di seguito, ecco prima la traccia.
Svolgete questa prima esercitazione nel file `lib/dart.dart`.

1. definisci una classe `Exercise` che rappresenta un esercizio svolto da uno studente, con i seguenti campi:
    - `name` il nome dello studente
    - `score` il punteggio ottenuto nell'esercizio (da 0 a 100)
    - `submittedAt` la data/ora in cui è stato svolto l'esercizio
2. aggiungi un getter `isPassed` che determina se il punteggio è sufficiente (i.e. maggiore o uguale a 60)
3. scrivi una funzione `passedOnly` che accetta una lista di esercizi e restituisce una nuova lista di esercizi con le sole sufficienze
4. scrivi una funzione `averageScore` che accetta una lista di esercizi e ne calcola il punteggio medio
5. scrivi una funzione `bestStudent` che accetta una lista di esercizi e restituisce il nome dello studente con il punteggio più alto

## esercizio Flutter

Di seguito, ecco la seconda traccia.
Svolgete questa seconda esercitazione nel file `lib/main.dart`.

**Project name**: MyFork

**Project Description**: An app to release reviews for local restaurants. The home screen lists all reviews, and a "+" button on the down/right opens a form to add a new one. We can always edit existing reviews by tapping the edit icon next to them.

**Important Note**: this exercise focuses on local state management using StatefulWidget; to help you, we are not requiring any global state management solution (Riverpod). You are free to choose to use it, but it's not required.

**Core Technical Requirements**:
  - write the class that represents a Review (with title, comment and rating fields); a rating is an integer from 1 to 5. comment is optional.
  - write two widgets: the home screen (list of reviews) and the "edit" widget form (used to add or to edit a review)
  - the home screen is a StatefulWidget that holds a list of reviews in its local state (or, write a notifier and use Riverpod if you prefer)
  - the form screen uses reactive_forms to create a form to build a new review
  - as always, the form screen pops with a `Map<String, Object?>` containing a validated form data
  - use the same form screen to edit an existing review, by accepting an optional review object to pre-fill the form fields
