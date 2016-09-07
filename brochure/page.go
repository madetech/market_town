package brochure

import (
	"encoding/json"
	"fmt"
	"net/url"
)

type Page struct {
	Id       *pageID       `json:"id"       valid:"required"`
	Release  PageRelease   `json:"release"  valid:"required"`
	Contents []PageContent `json:"contents" valid:"optional"`
}

type pageID struct {
	Host   string `json:"host"    valid:"required,host"`
	Path   string `json:"path"    valid:"required"`
	Locale string `json:"locale"  valid:"required"`
	URI    string `json:"uri"     valid:"required"`
}

func (pageID *pageID) UnmarshalJSON(data []byte) error {
	var pageIDFromJSON map[string]string
	err := json.Unmarshal(data, &pageIDFromJSON)
	if err != nil {
		return err
	}

	newPageID, err := PageIDFromURI(pageIDFromJSON["uri"])
	if err != nil {
		return err
	}

	pageID.Host = newPageID.Host
	pageID.Path = newPageID.Path
	pageID.Locale = newPageID.Locale
	pageID.URI = newPageID.URI
	return nil
}

func PageID(host string, path string, locale string) *pageID {
	uri := fmt.Sprintf("//%s%s?locale=%s", host, path, locale)
	return &pageID{host, path, locale, uri}
}

func PageIDFromURI(uri string) (*pageID, error) {
	u, err := url.Parse(uri)

	if err != nil {
		return nil, err
	}

	return &pageID{u.Host, u.Path, u.Query().Get("locale"), uri}, nil
}

type PageRelease struct {
	Timestamp int    `json:"timestamp" valid:"required"`
	UUID      string `json:"uuid"      valid:"required,uuid"`
}

type PageContent map[string]interface{}
