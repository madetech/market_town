package brochure

import (
	"log"
	"net/url"
)

type PageID struct {
	host   string
	path   string
	locale string
}

func (pageID PageID) Host() string   { return pageID.host }
func (pageID PageID) Path() string   { return pageID.path }
func (pageID PageID) Locale() string { return pageID.locale }

func PageIDFromURI(uri string) PageID {
	u, err := url.Parse(uri)

	if err != nil {
		log.Fatal(err)
	}

	return PageID{
		host:   u.Host,
		path:   u.Path,
		locale: u.Query().Get("locale"),
	}
}
