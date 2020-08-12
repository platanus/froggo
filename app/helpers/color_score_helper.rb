module ColorScoreHelper
  def matrix_pullrequest_color_modifier(color_scores, other_user)
    score = color_scores[other_user]
    return '' if invalid_score?(score)

    return ' matrix__pullrequest--red' if score <= 0.25
    return ' matrix__pullrequest--light-red' if score <= 0.5
    return ' matrix__pullrequest--green' if score <= 1.5
    return ' matrix__pullrequest--light-blue' if score <= 1.75

    ' matrix__pullrequest--blue'
  end

  private

  def invalid_score?(score)
    !score || score == -1.0
  end
end
