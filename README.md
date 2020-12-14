# omnisearch-api

A simple rails api application that provides search results from google and/or bing

## API endpoints

### GET /search

**Parameters**

|          Name | Required |  Type   | Description                                                                                                                                                           |
| -------------:|:--------:|:-------:| --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|     `engine` | required | string  | Search engine(s) to be used. <br/><br/> Supported values: `google, bing, both`.                                                                     |
|     `text` | required | string  | Search query.                                                                     |

**Response**
```
/* search?engine=both&text=elshaka */
{
  "status":"ok",
  "status_by_provider":[
    {
      "provider":"google",
      "status":"ok",
      "error_messages":null
    },
    {
      "provider":"bing",
      "status":"ok",
      "error_messages":null
    }
  ],
  "results":[
    {
      "provider":"google",
      "title":"elshaka (Eleazar Meza) · GitHub",
      "link":"https://github.com/elshaka"
    },
    {
      "provider":"google",
      "title":"Mn Kebd Kebd Elshaka by Maged Elkedwany on Amazon Music ...",
      "link":"https://www.amazon.com/Mn-Kebd-Elshaka-Maged-Elkedwany/dp/B085R8H58G"
    },
    {
      "provider":"google",
      "title":"Mexican singer El Shaka killed after denying his murder - BBC News",
      "link":"https://www.bbc.com/news/10429934"
    },
    {
      "provider":"google",
      "title":"Sergio Vega (singer) - Wikipedia",
      "link":"https://en.wikipedia.org/wiki/Sergio_Vega_(singer)"
    },
    {
      "provider":"google",
      "title":"Ahmed Elshaka (@ahmedelshaka) • Instagram photos and videos",
      "link":"https://www.instagram.com/ahmedelshaka/"
    },
    {
      "provider":"google",
      "title":"Emara fi elshaka Fi eloda 123 no | Grammar Quiz - Quizizz",
      "link":"https://quizizz.com/admin/quiz/5c7536ac613075001a2be023/emara-fi-elshaka-fi-eloda-123-no"
    },
    {
      "provider":"google",
      "title":"Elshaka Rivera | Facebook",
      "link":"https://www.facebook.com/elshaka.rivera.1"
    },
    {
      "provider":"google",
      "title":"Sergio Vega \"El Shaka\" - Quién Es Usted - YouTube",
      "link":"https://www.youtube.com/watch?v=s3_tYVxnOCE\u0026list=PLkeWGZZJ6BwM9fAXg9SNf6b5g12LwHRkP\u0026index=223"
    },
    {
      "provider":"google",
      "title":"Bank Alrahaman Awad Elshaka | Facebook",
      "link":"https://www.facebook.com/bankalrahamanawad.elshaka/photos"
    },
    {
      "provider":"google",
      "title":"The Violent Death of Sergio 'El Shaka' Vega, Drug Balladeer - WSJ",
      "link":"https://www.wsj.com/articles/BL-SEB-39394"
    },
    {
      "provider":"bing",
      "title":"Sergio Vega \"El Shaka\" - Quién Es Usted - YouTube",
      "link":"https://www.youtube.com/watch?v=s3_tYVxnOCE"
    },
    {
      "provider":"bing",
      "title":"El shaka: qué significa la señal y dónde se originó",
      "link":"https://www.elnacional.com/gda/el-shaka-que-significa-la-senal-y-donde-se-origino/"
    },
    {
      "provider":"bing",
      "title":"El shaka: qué significa esta señal y dónde se originó",
      "link":"https://www.eluniversal.com.mx/destinos/el-shaka-que-significa-esta-senal-y-donde-se-origino"
    },
    {
      "provider":"bing",
      "title":"Sergio Vega - Wikipedia, la enciclopedia libre",
      "link":"https://es.wikipedia.org/wiki/Sergio_Vega"
    },
    {
      "provider":"bing",
      "title":"El Shaka (letra y canción) - Sergio Vega | Musica.com",
      "link":"https://www.musica.com/letras.asp?letra=1400579"
    },
    {
      "provider":"bing",
      "title":"El Shaka: orígenes de un gesto que forma parte de la ...",
      "link":"https://wipeoutsurfmag.com/saludo-shaka-origenes/"
    },
    {
      "provider":"bing",
      "title":"Shaka Hawaii",
      "link":"https://www.to-hawaii.com/es/shaka.php"
    },
    {
      "provider":"bing",
      "title":"elshaka (Eleazar Meza) · GitHub",
      "link":"https://github.com/elshaka"
    },
    {
      "provider":"bing",
      "title":"Shaka - Wikipedia, la enciclopedia libre",
      "link":"https://es.wikipedia.org/wiki/Shaka"
    }
  ]
}
```

## Live version

[omnisearch-api @ Heroku](https://omnisearch-elshaka.herokuapp.com/search?engine=google&text=test%20query)

## Installation and getting started

```
git clone https://github.com/elshaka/omnisearch-api
cd 'omnisearch-api'
bundle install
```

In order for the google search to work, you'd need to setup the environment variables GOOGLE_ENGINE_ID and GOOGLE_API_KEY with valid credentials.

For bing search you'd need to provide a bing subscription key using the environment variable BING_SUBSCRIPTION_KEY

You could then run the server like this:

```
GOOGLE_ENGINE_ID=<YOUR GOOGLE ENGINE ID> GOOGLE_API_KEY=<YOUR GOOGLE API KEY> BING_SUBSCRIPTION_KEY=<YOUR BING SUBSCRIPTION KEY> rails s
```

You'd also need a redis instance running, the rails app will try to connect by default to ```localhost:6379```, you can also provide a custon redis url setting the environment variable REDIS_URL before running the rails server.

## Testing

```
GOOGLE_ENGINE_ID=<YOUR GOOGLE ENGINE ID> GOOGLE_API_KEY=<YOUR GOOGLE API KEY> BING_SUBSCRIPTION_KEY=<YOUR BING SUBSCRIPTION KEY> bundle exec rspec
```

VCR is used to record the test suite HTTP interactions but you still need to provide the relevant credentials as environment variables to make use of the proper cassettes.

## Author

👤 **Eleazar Meza**

- Github: [@elshaka](https://github.com/elshaka)
- Twitter: [@elshaka](https://twitter.com/elshaka)
- Linkedin: [Eleazar Meza](https://www.linkedin.com/in/elshaka/)
