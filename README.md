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
/* search?engine=google&text=test%20query */
{
  "status":"ok",
  "query":"test query",
  "engines_results":[
    {
      "provider":"google",
      "status":"ok",
      "error_message":null,
      "data":[
        {
          "title":"Efficient SQL test query or validation query that will work across all ...",
          "link":"https://stackoverflow.com/questions/3668506/efficient-sql-test-query-or-validation-query-that-will-work-across-all-or-most"
        },
        {
          "title":"Test an Azure Stream Analytics job with sample data | Microsoft Docs",
          "link":"https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-test-query"
        },
        {
          "title":"Is there a command to test an SQL query without executing it ...",
          "link":"https://stackoverflow.com/questions/2433633/is-there-a-command-to-test-an-sql-query-without-executing-it-mysql-or-ansi-sq"
        },
        {
          "title":"Test Query",
          "link":"https://app.provable.xyz/home/test_query"
        },
        {
          "title":"Queries | Testing Library",
          "link":"https://testing-library.com/docs/dom-testing-library/api-queries"
        },
        {
          "title":"NHTSA VSR | Query on Vehicle Database based on selected Test ...",
          "link":"https://www-nrd.nhtsa.dot.gov/database/VSR/veh/QueryVehicle.aspx"
        },
        {
          "title":"Test Query Pipeline Changes",
          "link":"https://docs.coveo.com/en/1845/"
        },
        {
          "title":"Testing Apollo's Query Component - Apollo Blog",
          "link":"https://www.apollographql.com/blog/testing-apollos-query-component-d575dc642e04/"
        },
        {
          "title":"Testing Query Language (TQL)",
          "link":"https://help.catchsoftware.com/pages/viewpage.action?pageId=28444734"
        },
        {
          "title":"Testing React components - Client (React) - Apollo GraphQL Docs",
          "link":"https://www.apollographql.com/docs/react/development-testing/testing/"
        }
      ]
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

## Author

👤 **Eleazar Meza**

- Github: [@elshaka](https://github.com/elshaka)
- Twitter: [@elshaka](https://twitter.com/elshaka)
- Linkedin: [Eleazar Meza](https://www.linkedin.com/in/elshaka/)
