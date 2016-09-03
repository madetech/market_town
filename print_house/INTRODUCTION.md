# Introduction to releasing content

PrintHouse provides the logic for receiving **Content** such as an article, promotion block or product and storing it in a database. The Content can contain translations for various locales. The Content is received as an object and stored as a revision in a database.

Once Content has been received it can then be attributed to one or more **Resources**. You can think of a Resource as a web page. A Resource can belong to one or more **Sites**.

**Releases** are created in order to make updates to Resources. A **Change** is created per Resource to modify the latter's Contents. Changes are also used to represent a modification or removal of content. A Release will have a release time, a specific time when the Release should be put live.

Every time a Release is created, updated or deleted, Resources affected by the Release are either indexed or removed from the index. The release time is also placed inside the indexed Resource so that we can query for all Resource versions before a certain time. This also allows us in a special administrator mode to view future releases with a change to the query.

## Glossary

 - **Content** is an article, promotion block, product, etc. in one or more locales
 - **Revision** is an object that represents a particular revision of Content
 - **Resource** is a collection of Content, much like a web page
 - **Site** is a collection of Resources, much like a web site
 - **Release** is a collection of Changes to be made to a Site at a certain time
 - **Change** is a change to the Contents of a Resource

## Objects in database

### Revision

``` ruby
{ reference: 'any unique string',
  created_at: 1469810808,
  translations: { 'en-GB': { title: 'A blog post',
                             body: 'Some content' } } }
```

### Resource

``` ruby
{ site_id: 1,
  path: '/blog/a-blog-post' }
```

### Site

``` ruby
{ domain: 'madetech.com' }
```

### Change

``` ruby
{ resource_id: 1,
  contents: [] }
```

### Release

``` ruby
{ guid: '0000-00-0000'
  release_at: 1469810808,
  change_ids: [1, 2] }
```

## Indexed resource

``` ruby
{ id: 'madetech.com/en-GB/blog/a-blog-post',
  timestamp: 1469810808,
  release_guid: '0000-00-0000',
  content: [{ title: 'A blog post',
              body: 'Some content' }] }
```
