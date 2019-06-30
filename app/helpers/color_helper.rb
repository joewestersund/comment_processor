module ColorHelper

  def colors_available
      color_array = [
          ['red', 'indianred'],
          ['red', 'lightcoral'],
          ['red', 'salmon'],
          ['red', 'darksalmon'],
          ['red', 'lightsalmon'],
          ['red', 'crimson'],
          ['red', 'red'],
          ['red', 'firebrick'],
          ['red', 'darkred'],
          ['pink', 'pink'],
          ['pink', 'lightpink'],
          ['pink', 'hotpink'],
          ['pink', 'deeppink'],
          ['pink', 'mediumvioletred'],
          ['pink', 'palevioletred'],
          ['orange', 'lightsalmon'],
          ['orange', 'coral'],
          ['orange', 'tomato'],
          ['orange', 'orangered'],
          ['orange', 'darkorange'],
          ['orange', 'orange'],
          ['yellow', 'gold'],
          ['yellow', 'yellow'],
          ['yellow', 'lightyellow'],
          ['yellow', 'lemonchiffon'],
          ['yellow', 'lightgoldenrodyellow'],
          ['yellow', 'papayawhip'],
          ['yellow', 'moccasin'],
          ['yellow', 'peachpuff'],
          ['yellow', 'palegoldenrod'],
          ['yellow', 'khaki'],
          ['yellow', 'darkkhaki'],
          ['purple', 'lavender'],
          ['purple', 'thistle'],
          ['purple', 'plum'],
          ['purple', 'violet'],
          ['purple', 'orchid'],
          ['purple', 'fuchsia'],
          ['purple', 'magenta'],
          ['purple', 'mediumorchid'],
          ['purple', 'mediumpurple'],
          ['purple', 'rebeccapurple'],
          ['purple', 'blueviolet'],
          ['purple', 'darkviolet'],
          ['purple', 'darkorchid'],
          ['purple', 'darkmagenta'],
          ['purple', 'purple'],
          ['purple', 'indigo'],
          ['purple', 'slateblue'],
          ['purple', 'darkslateblue'],
          ['purple', 'mediumslateblue'],
          ['green', 'greenyellow'],
          ['green', 'chartreuse'],
          ['green', 'lawngreen'],
          ['green', 'lime'],
          ['green', 'limegreen'],
          ['green', 'palegreen'],
          ['green', 'lightgreen'],
          ['green', 'mediumspringgreen'],
          ['green', 'springgreen'],
          ['green', 'mediumseagreen'],
          ['green', 'seagreen'],
          ['green', 'forestgreen'],
          ['green', 'green'],
          ['green', 'darkgreen'],
          ['green', 'yellowgreen'],
          ['green', 'olivedrab'],
          ['green', 'olive'],
          ['green', 'darkolivegreen'],
          ['green', 'mediumaquamarine'],
          ['green', 'darkseagreen'],
          ['green', 'lightseagreen'],
          ['green', 'darkcyan'],
          ['green', 'teal'],
          ['blue', 'aqua'],
          ['blue', 'cyan'],
          ['blue', 'lightcyan'],
          ['blue', 'paleturquoise'],
          ['blue', 'aquamarine'],
          ['blue', 'turquoise'],
          ['blue', 'mediumturquoise'],
          ['blue', 'darkturquoise'],
          ['blue', 'cadetblue'],
          ['blue', 'steelblue'],
          ['blue', 'lightsteelblue'],
          ['blue', 'powderblue'],
          ['blue', 'lightblue'],
          ['blue', 'skyblue'],
          ['blue', 'lightskyblue'],
          ['blue', 'deepskyblue'],
          ['blue', 'dodgerblue'],
          ['blue', 'cornflowerblue'],
          ['blue', 'mediumslateblue'],
          ['blue', 'royalblue'],
          ['blue', 'blue'],
          ['blue', 'mediumblue'],
          ['blue', 'darkblue'],
          ['blue', 'navy'],
          ['blue', 'midnightblue'],
          ['brown', 'cornsilk'],
          ['brown', 'blanchedalmond'],
          ['brown', 'bisque'],
          ['brown', 'navajowhite'],
          ['brown', 'wheat'],
          ['brown', 'burlywood'],
          ['brown', 'tan'],
          ['brown', 'rosybrown'],
          ['brown', 'sandybrown'],
          ['brown', 'goldenrod'],
          ['brown', 'darkgoldenrod'],
          ['brown', 'peru'],
          ['brown', 'chocolate'],
          ['brown', 'saddlebrown'],
          ['brown', 'sienna'],
          ['brown', 'brown'],
          ['brown', 'maroon'],
          ['white', 'white'],
          ['white', 'snow'],
          ['white', 'honeydew'],
          ['white', 'mintcream'],
          ['white', 'azure'],
          ['white', 'aliceblue'],
          ['white', 'ghostwhite'],
          ['white', 'whitesmoke'],
          ['white', 'seashell'],
          ['white', 'beige'],
          ['white', 'oldlace'],
          ['white', 'floralwhite'],
          ['white', 'ivory'],
          ['white', 'antiquewhite'],
          ['white', 'linen'],
          ['white', 'lavenderblush'],
          ['white', 'mistyrose'],
          ['gray', 'gainsboro'],
          ['gray', 'lightgray'],
          ['gray', 'silver'],
          ['gray', 'darkgray'],
          ['gray', 'gray'],
          ['gray', 'dimgray'],
          ['gray', 'lightslategray'],
          ['gray', 'slategray'],
          ['gray', 'darkslategray'],
          ['gray', 'black']
      ]
  end

  def color_category_and_names_list
    colors_available.each_with_index.map do |subarray, index|
      [ index, "#{subarray[0]} | #{subarray[1]}" ]
    end
  end

  def color_class(klass)
    if klass.present? && klass.color_name.present?
      "bg_color_#{klass.color_name}"
    else
      ""
    end
  end

  def get_color_id(color_name)
    if color_name.present?
      #note: color_id is zero based, like the array indices. So first color (indianred) has color_id = 0
      colors_available.map{ |subarray| subarray[1]}.index(color_name)
    else
      nil
    end
  end

  def get_color_name(color_id)
    if color_id.present?
      colors_available[color_id.to_i][1]
    else
      ""
    end
  end

end