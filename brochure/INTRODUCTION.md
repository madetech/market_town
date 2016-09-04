# Introduction to using Brochure as code

## Connecting to ElasticSearch

``` go
import "github.com/madetech/market_town/brochure"
conn := brochure.Connection()
```

## Indexing Page

### Create/updating Page indexes

``` go
err := brochure.CreatePageIndex(conn)
err := brochure.UpdatePageIndex(conn)
```

### Creating Page

``` go
newPage := brochure.Page{
  id: brochure.PageIDFromURI("madetech.com/blog/a-blog-post?locale=en-GB")),
  release: brochure.PageRelease{
    timestamp: 1469810808,
    uuid: "f5826bba-4496-4361-a061-e8b76ec0971d"
  },
  contents: []brochure.PageContent{
    brochure.PageContent{ title: "Cool" }
  },
}
```

### Indexing Page

``` go
brochure.IndexPage(conn, newPage)
```

## Retrieving a Page

Current version:

``` go
page, err := brochure.FindPage(
  conn,
  brochure.PageIDFromURI("madetech.com/blog/a-blog-post?locale=en-GB"),
)

json, err := page.JSON()
```

Version at specified time:

``` go
import "time"

brochure.FindPage(
  conn,
  brochure.PageIDFromURI("madetech.com/blog/a-blog-post?locale=en-GB"),
  time.Now(),
)
```

By composite PageID:

``` go
brochure.FindPage(
  conn,
  brochure.PageID{
    domain: "madetech.com",
    path: "/blog/a-blog-post",
    locale: "en-GB",
  },
)
```
