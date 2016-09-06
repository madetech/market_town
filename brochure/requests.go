package brochure

import (
	"encoding/json"
	"github.com/asaskevich/govalidator"
	"net/http"
)

type indexPageRequest struct {
	Page Page `json:"page" valid:"required"`
}

func IndexPageRequest(request http.Request) (indexPageRequest, error) {
	var indexPageRequest indexPageRequest

	decoder := json.NewDecoder(request.Body)
	if err := decoder.Decode(&indexPageRequest); err != nil {
		return indexPageRequest, err
	}

	if valid, err := govalidator.ValidateStruct(indexPageRequest); !valid {
		return indexPageRequest, err
	}

	return indexPageRequest, nil
}
