# Dublin Bikes

Real-time Dublin Bikes planner: live station availability on a map, weather, station-to-station journey planning, ML availability forecasts and an LLM chat assistant. Flask + MySQL, deployed on AWS (EC2 + RDS) behind nginx.

**Live:** [bikes.seancai.dev](https://bikes.seancai.dev)

---

## Features

- **Live station map**: bikes and free stands for every JCDecaux Dublin station, refreshed from a scraper that writes to MySQL.
- **Weather**: current conditions and 3-hour / 5-day forecast from OpenWeatherMap.
- **Journey planner**: pick-up and drop-off station suggestions with Google Maps routing.
- **Availability forecast**: two-stage scikit-learn pipeline (weather model → per-station bike model) predicting availability by hour.
- **AI assistant**: chat about stations, routes and the city, backed by Groq (`openai/gpt-oss-120b`, configurable). A Gemini backend is also included.
- **Accounts**: register/login with Flask-WTF + Werkzeug password hashing (hidden in the public deployment).

## Tech stack

| Layer | Technology |
|---|---|
| Backend | Python 3.10+, Flask 3.1 (blueprints + app factory), SQLAlchemy, PyMySQL |
| Frontend | Jinja2 templates, vanilla JavaScript, CSS, Google Maps JavaScript API |
| Data | JCDecaux API, OpenWeatherMap API, MySQL 8 |
| ML | scikit-learn, pandas, numpy |
| LLM | Groq API, Google Gemini API |
| Deployment | AWS EC2 + RDS, gunicorn, nginx, systemd, Let's Encrypt |
| Docs / tests | Sphinx, unittest + coverage |

## Architecture

```
JCDecaux / OpenWeatherMap ──► scrapers (systemd) ──► MySQL (RDS)
                                                        │
Browser ──HTTPS──► nginx ──► gunicorn ──► Flask app ────┤
                                │                       └─► ML forecast models
                                └─► Google Maps, Groq / Gemini APIs
```

## Project structure

```
├── app.py                     # Entry point: create_app() + CORS for /api/*
├── main_project/
│   ├── __init__.py            # App factory, blueprint registration
│   ├── config.py              # Config loaded from .env / var.env
│   ├── db.py                  # SQLAlchemy engines
│   ├── auth/  home/  station/  weather/  journey/  chat/
│   ├── bike_forecast/         # Forecast routes + model loading/prediction
│   ├── notebooks/             # Model training notebooks
│   ├── templates/  static/    # Jinja2 pages, JS, CSS, icons
│   └── bash_scripts/          # DB creation and scraper helpers
├── sprint1_webscrappers/      # JCDecaux / OpenWeather scrapers (webscrapping_ec2/ runs in production)
├── sprint2_flask_cd/          # Sprint 2 Flask prototype
├── sprint3_frontend_react_wjl/# Sprint 3 React prototype
├── deploy/                    # schema.sql, systemd units, nginx config
├── test.py                    # Unit tests
└── Gen AI Logs/               # Per-member AI usage logs
```

## Getting started

**Prerequisites:** Python 3.10+, MySQL 8+.

```bash
git clone https://github.com/seanchoy/dublin-bikes.git
cd dublin-bikes
python -m venv venv && source venv/bin/activate
pip install -r requirement.txt
```

Configure environment variables (see [`.env.example`](.env.example) for the full list):

```bash
cp .env.example .env
```

Create the databases and tables:

```bash
mysql -u root -p < deploy/schema.sql
```

Run the app (defaults to `http://0.0.0.0:8000`; override with `HOST` / `PORT`):

```bash
python app.py
```

The trained forecast models (`main_project/bike_forecast/models/*.pkl`, ~2 GB) are not in the repo. Generate them with the notebooks in `main_project/notebooks/`; the rest of the app runs without them.

## Tests

```bash
python -m unittest test.py -v
```

## Deployment

Production runs on EC2 with the app in `/srv/dublin-bikes`:

- `deploy/dublin-bikes.service`: gunicorn, 1 worker × 8 threads (each worker loads the forecast models).
- `deploy/dublin-bikes-scraper@.service`: one instance per scraper, e.g. `dublin-bikes-scraper@jcdecaux`.
- `deploy/nginx.conf`: TLS termination, static files, reverse proxy to gunicorn.
- `deploy/schema.sql`: station, availability, weather and users tables on RDS.

## Links

- [Figma mockup](https://www.figma.com/design/hTWVkDQys1NVg8Z7n2yyXK/Software-Engineering?node-id=0-1&p=f&t=4nAaHxQFGe30qwF2-0)
- [Personas, interviews, PRD and backlog](https://drive.google.com/drive/folders/1maMOySvNugMCGIAmODOntPJsiAVLn2Hl?usp=sharing)
- [Sphinx API docs](https://shayan-ashish-chakraborty.github.io/dublin-bikes-team20/)

---

<sub>Built as a Team 20 group project for the Software Engineering module at University College Dublin. Team: Jialin, Leah, Shayan, Shida. Original team repo: <a href="https://github.com/shayan-ashish-chakraborty/dublin-bikes-team20">shayan-ashish-chakraborty/dublin-bikes-team20</a>.</sub>
