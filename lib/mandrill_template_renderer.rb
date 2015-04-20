class MandrillTemplateRenderer
  MANDRILL_PREFIX    = /\*\|/
  MANDRILL_SUFFIX    = /\|\*/

  IF_BLOCK_PREFIX    = /^IF\:/
  IF_BLOCK_SUFFIX    = /END\:IF/

  def initialize(template)
    @mandrill_template = template
    @hash = {}
  end

  def to_s(hash)
    @hash = hash
    cut_left = @mandrill_template.split(MANDRILL_PREFIX)

    result_string = cut_left.shift  # html snippet on the front

    until cut_left.empty?
      control_code, static_section = cut_left.shift.split(MANDRILL_SUFFIX)
      control_code.strip!
      if control_code =~ IF_BLOCK_PREFIX
        result_string += render_to_end_of_block(control_code, static_section, cut_left)
      else
        result_string += attempt_to_substitute(control_code, hash) + static_section.to_s
      end
    end

    result_string
  end

  private

  def render_to_end_of_block(control_code, initial_section, list_of_sections)
    key = control_code.sub(IF_BLOCK_PREFIX,'').strip
    result = initial_section.to_s
    until list_of_sections.empty?
      control_code, static_section = list_of_sections.shift.split(MANDRILL_SUFFIX)
      control_code.strip!
      if control_code =~ IF_BLOCK_PREFIX
        result += render_to_end_of_block(control_code, static_section, list_of_sections)
      elsif control_code =~ IF_BLOCK_SUFFIX
        if @hash[key]
          return result + static_section.to_s
        else
          return static_section.to_s
        end
      else
        result += attempt_to_substitute(control_code, hash) + static_section.to_s
      end
    end

    # The list is empty but we never saw a trailing IF_BLOCK_SUFFIX
    raise "Invalid Mandrill template, around #{[key, result, control_code]}"
  end

  def attempt_to_substitute(control_code, hash)
    (hash[control_code] || (MANDRILL_PREFIX+control_code+MANDRILL_SUFFIX)).to_s
  end
end
