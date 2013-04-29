module MicropostsHelper

  def wrap(content)
  	#1.split the content into separate words (i.e using the default whitespace)
  	#2.map each resulting string using the provided block function
  	#3.this means, process each string with wrap_long_string which puts the
  	#  zerwowidthspace character if the string is too long
  	#4. recreate the original string by doing the inverse of the split (join with whitespace)
  	#5. apply the raw function to prevent de default HTML escaping from rails
  	#6. apply sanitize: This sanitize helper will html encode all tags and strip all attributes that aren’t specifically allowed.
    content.split.map{ |s| wrap_long_string(s) }.join(' ')

  end

  private

    def wrap_long_string(text, max_width = 30)
    #return a string with a zero width space every 30 chars
      zero_width_space = "&#8203;" #string with hexa valueof the zerowidth space
      regex = /.{1,#{max_width}}/ #default. /.{1,30}/ returns arrays of 30 letters of the original string separated by spaces
      (text.length < max_width) ? text : 
                                  text.scan(regex).join(zero_width_space) # rejoin the string array using the zero_width space
    end
 end