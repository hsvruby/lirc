Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      
      String :twitter_username
      String :twitter_access_token
      
      DateTime :created_at
      DateTime :updated_at
    end
    
    create_table(:messages) do
      primary_key :id
      foreign_key :created_by,  :users
      foreign_key :location_id, :locations
      
      Text :text
      
      DateTime :created_at
      DateTime :updated_at
    end

    create_table(:locations) do
      primary_key :id
      
      Float :lat
      Float :lng
      
      String :foursquare_venue_id
      
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table(:locations)
    drop_table(:messages)
    drop_table(:users)
  end
end
