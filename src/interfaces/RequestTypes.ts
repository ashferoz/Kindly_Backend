export interface AddRequestBody {
  user_uuid: string;
  title: string;
  details: string;
  request_category: string;
  request_urgency: string;
  request_location: string;
}

export interface GetRequestBody {
  user_uuid: string;
}

export interface DelRequestParams {
  request_id: string;
}

export interface UpdateRequestBody {
  title?: string;
  details?: string;
  request_category?: string;
  request_urgency?: string;
  request_location?: string;
  request_status?: string;
}

export interface UpdateRequestParams {
  request_id: string;
}

export interface ConnectToRequestBody {
  volunteer_uuid: string;
}

export interface ConnectToRequestParams {
  connect_request_id: string;
}
