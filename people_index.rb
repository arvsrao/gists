 define_type Person.includes(:activities, :degrees, :employments, :applications, :keywords) do
    field :first_name, :last_name, :nickname
    field :name, index: 'not_analyzed', value: -> { (nickname.present?) ? "#{nickname} #{last_name}".strip : "#{first_name} #{last_name}".strip }
    field :primary_email, analyzer: 'email'
 
field :employments, type: 'nested', include_in_parent: true do
      field :win, type: 'boolean', value: -> { is_win? }
      field :current, type: 'boolean', value: -> { end_date.include?('Present') ? true : false }
      field :company, type: 'nested', include_in_parent: true, value: -> {
                      if company && company.id === 1 && missing_company_name
                        return Company.new(
                          name: missing_company_name,
                          updated_at: updated_at,
                          last_updater_id: last_updater_id,
                          creator_id: creator_id,
                          created_at: created_at,
                          id: 1
                        )
                      end
                      return company
                    } do
        field :name_not_analyzed, index: 'not_analyzed', value: -> { return PeopleIndex::parse_title(name) }
        field :updated_at, type: 'date'
        field :creator_id, type: 'integer'
        field :id, type: 'integer'
      end
      field :title_not_analyzed, index: 'not_analyzed', value: -> { PeopleIndex::parse_title(title) }
      field :creator_id, type: 'integer'
      field :id, type: 'integer'
    end
  end