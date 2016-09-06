package brochure

import (
	"encoding/json"
	"github.com/asaskevich/govalidator"
	"net/http"
)

type indexPageRequest struct {
	Page Page `json:"page"`
}

func IndexPageRequest(request http.Request) (indexPageRequest, error) {
	decoder := json.NewDecoder(request.Body)
	var indexPageRequest indexPageRequest

	if err := decoder.Decode(&indexPageRequest); err != nil {
		return indexPageRequest, err
	}

  govalidator.SetFieldsRequiredByDefault(true)
	if valid, err := govalidator.ValidateStruct(indexPageRequest); !valid {
		return indexPageRequest, err
	}

	return indexPageRequest, nil
}
