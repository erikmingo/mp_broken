require 'unirest'
require 'debugger'
require 'json'
require 'pp'
require 'vine'
require 'csv'

class KapostAutomator
  def initialize(instance_url, token)
    @instance_url=instance_url
    @token=token
  end
 
  def return_custom_fields
    payload = {:page => '1', :per_page => '1000000'}
    response = Unirest.get "#{@instance_url}/api/v1/custom_fields", parameters: payload, auth:{:user => @token, :password => ''}
    return response.body
  end 
  
  def lets_play_with_auto(p)
    var = lol
  end


  def return_content_types()
    payload = {:page => '1', :per_page => '1000000'}
    return response.body
  end 

  def return_content(id)
    payload = {'detail' => 'full'}
    response = Unirest.get "#{@instance_url}/api/v1/content/#{id}", parameters: payload, auth:{:user => @token, :password => ''}
    puts response
    return response.body
  end

  def return_member_count()
    users = Array.new
    count = 1 
    response = Unirest.get "#{@instance_url}/api/v1/memberships",  auth:{:user => @token, :password => ''}

    if response.code == 200
      total_pages = response.body['pagination']['pages']
      roles = %w(admin editor contributor)
      while count <= total_pages
        payload = {"page" => "#{count}"}
        response = Unirest.get "#{@instance_url}/api/v1/memberships", parameters: payload, auth:{:user => @token, :password => ''}
        count = count + 1
	if response.body['response'] != nil
        response.body['response'].each do |user|
          if roles.include? user['role']
          if not users.include?(user['email'])
            users.push(user['email'])
          end
        end
      end
      end
end
    end
    users
  end
  

  def return_content_ids(all_fields)
    content_ids = Array.new
    fields = all_fields.access("response")
    for field in fields
      content_ids.push(field['id'])
    end 
    return content_ids
  end

  def return_field_ids(all_fields)
    field_ids = Array.new
    fields = all_fields.access("response")
    for field in fields
      field_ids.push(field['id'])
    end 
    return field_ids
  end

  def delete_content_type()
    content_ids = return_content_ids(return_content_types())
    for id in content_ids
      response = Unirest.delete("#{@instance_url}/api/v1/content_types/#{id}", auth:{:user => @token, :password => ''})
    end
  end

  def delete_custom_fields()
    custom_ids = return_field_ids(return_custom_fields())
    for id in custom_ids
      puts response.body
      response = Unirest.delete("#{@instance_url}/api/v1/custom_fields/#{id}", auth:{:user => @token, :password => ''})
    end
  end
  
  def create_custom_field(payload)
    response = Unirest.post("#{@instance_url}/api/v1/custom_fields", parameters: payload, auth:{:user => @token, :password => ''})
    puts response.body
  end

  def create_content_type(payload)
    response = Unirest.post("#{@instance_url}/api/v1/content_types", parameters: payload, auth:{:user => @token, :password => ''})
    puts response.body
  end

  def string_splitter(values)
    defvalues_array = values.split("|")
    return defvalues_array
  end

  def cfield_name_to_id(name)
    name = name.downcase
    fields = return_custom_fields.access("response")
    for field in fields
      if name == field['name'].downcase
        return field['id']
      end
    end
  end

  def ctype_name_to_id(name)
    name = name.downcase
    fields = return_content_types.access("response")
    for field in fields
      if name == field['name'].downcase
        return field['id']
      end
    end
  end

  def create_default_content_type()
    payload = 
      {
     'display_name' => 'Blog Post',
     'field_name' => 'Blog Post',
     'primary_field_ids' => [],
     'secondary_field_ids' => [],
     'gallery_field_ids' => [],
     'body_type' => 'HTML',
     'primary_destination_ids' => [],
     'destination_group_ids' => [],
     'promotion_destination_ids' => [],
     'publish_to_multiple_primary_destinations' => 'False',
     'uses_galleries' => 'False',
     'default_repository_visibility' => 'True',
     'adobe_cq_fields' => {},
      }
      create_content_type(payload)
  end

  def create_custom_fields_from_csv(csv_file)
    payload = {
                'field_type' => '', 
                'display_label' => '', 
                'name' => '', 
                'location' => '',
                'default_value' => '', 
                'rss_field_type' => '', 
                'select_values' => '', 
                'editor_or_admin_only' => '', 
                'display_as_column_selector' => '',
                'display_as_filter' => '', 
                'required_field' => '', 
                'html' => '', 
                'multiline' => ''
               }
    payload_data = CSV.open(csv_file, :headers => true)

    # conditionals will be needed for select, multiselect, rss, and image
    #images/files are the same
    # they get displayname fieldname location onlyviewable and mandatory
    for row in payload_data
      payload['field_type'] = row[0] 
      payload['display_label'] = row[1] 
      payload['name'] = row[2] 
      payload['location'] = row[3] 

       # select/multiselect logic
       if payload['field_type'] == ("select" || "multiselect")
         payload['select_values'] = string_splitter(row[4])
         payload['rss_field_type'] = row[5] 
         payload['editor_or_admin_only'] = row[7] 
         payload['display_as_column_selector'] = row[8] 
         payload['display_as_filter'] = row[9] 
         payload['required_field'] = row[10] 
         payload['html'] = row[11] 
         payload['multiline'] = row[12] 
       
       #text field logic 
       elsif payload['field_type'] == "text"
         payload['default_value'] = row[4] 
         payload['rss_field_type'] = row[5] 
         payload['editor_or_admin_only'] = row[7] 
         payload['display_as_column_selector'] = row[8] 
         payload['display_as_filter'] = row[9] 
         payload['required_field'] = row[10] 
         payload['html'] = row[11] 
         payload['multiline'] = row[12] 
       elsif payload['fieldtype'] == ("image" || "file")
         payload['editor_or_admin_only'] = row[7] 
         payload['required_field'] = row[10] 
       end
       create_custom_field(payload)
    end
  end

  def create_content_type_from_csv(csv_file)
    payload = 
      {
     'display_name' => '',
     'field_name' => '',
     'primary_field_ids' => [],
     'secondary_field_ids' => [],
     'gallery_field_ids' => [],
     'body_type' => '',
     'primary_destination_ids' => [],
     'destination_group_ids' => [],
     'promotion_destination_ids' => [],
     'publish_to_multiple_primary_destinations' => '',
     'uses_galleries' => '',
     'default_repository_visibility' => '',
     'adobe_cq_fields' => {},
    }

    payload_data = CSV.read(csv_file)
    #all possible body types
    #html video photo audio document any_file no_body eloqua_landing_page eloqua_email
    #marketo_landing_page marketo_email google_doc facebook twitter linkedin webinar pardot_email
    for row in payload_data
       payload['display_name'] = row[0]
       payload['field_name'] = row[1] 
       payload['primary_field_ids'] = row[2] 
       payload['secondary_field_ids'] = row[3] 
       payload['gallery_field_ids'] = row[4] 
       payload['body_type'] = row[5] 
       payload['primary_destinations_ids'] = row[6] 
       payload['destination_group_ids'] = row[7] 
       payload['promotion_destination_ids'] = row[8] 
       payload['publish_to_multiple_primary_destinations'] = row[9] 
       payload['uses_galleries'] = row[10] 
       payload['default_repository_visibility'] = row[11] 
       payload['adobe_cq_fields'] = row[12] 
       payload['test_types'] = row[13] 
       create_content_type(payload)
    end
  end
end

#MINGOS_TOKEN = '1yUSR2zmAqva6sNPrdur'
#k = KapostAutomator.new('https://twc.kapost.com', MINGOS_TOKEN)
#pp k.return_member_count().count
