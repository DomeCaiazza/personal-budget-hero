# Personal Budget Hero

**[English](README.md) | [Italiano](README.it.md)**

È un'applicazione web progettata per gestire le finanze personali.
PBH è composta da una console web con interfaccia utente semplice e un'interfaccia ottimizzata per dispositivi mobili per gestire facilmente le transazioni del tuo account.

## Funzionalità interfaccia Console

- **Gestione multi-account**: Crea e passa tra più account (portafogli)
- **CRUD transazioni entrate e uscite** con filtri avanzati (per intervallo di date, categoria, descrizione)
- **CRUD categorie di transazioni** con colori personalizzati e tipi (spese, entrate, abbonamenti)
- **CRUD abbonamenti** (mensili, trimestrali, semestrali, annuali) con generazione automatica di transazioni
- **Dashboard** con report mensile delle transazioni per categoria
- **Report transazioni** con:
  - Totale spese e entrate
  - Calcolo del risparmio
  - Previsioni delle spese
  - Previsioni del risparmio
  - Media delle spese giornaliere
- **Autorizzazione utenti** con controllo degli accessi basato sui ruoli (Pundit)

### Funzionalità future Console

- CRUD obiettivi di risparmio per gestire i risparmi.

## Funzionalità interfaccia Mobile (Webapp)

- **CRUD transazioni entrate e uscite**
- **CRUD categorie di transazioni**

### Funzionalità future Mobile

- Ottimizzazione dell'interfaccia grafica.

## Tecnologie

- **Ruby** 3.3.5
- **Rails** 8.1
- **MySQL** 8
- **Tailwind CSS** 4.4.0
- **Bootstrap** 5.3.3
- **Devise** 4.9 (Autenticazione)
- **Pundit** 2.4 (Autorizzazione)
- **Ransack** (Ricerca e filtri avanzati)
- **Kaminari** (Paginazione)
- **Turbo Rails** (Navigazione SPA-like Hotwire)
- **Stimulus** (JavaScript framework)
- **RSpec** (Test)

## Installazione

1. Clona il repository
```git clone git@github.com:DomeCaiazza/personal-budget-hero.git```
2. Installa le dipendenze
```bundle install```
3. Crea il database
```rails db:create```
4. Esegui le migrazioni
```rails db:migrate```
5. Esegui i test
```rspec```
6. Avvia il server
```rails s```
   
## Utilizzo

1. Apri il browser e vai su http://localhost:3000
2. Registrati e accedi

## Contribuire

I pull request sono benvenuti. Per modifiche importanti, apri prima una issue per discutere cosa vorresti cambiare.

Dai un'occhiata qui: https://github.com/users/DomeCaiazza/projects/1

## Licenza

Questo progetto è licenziato sotto la MIT License - vedi il file [LICENSE.md](LICENSE.md) per i dettagli

## Autore
[Domenico Caiazza](https://domenicocaiazza.com)

