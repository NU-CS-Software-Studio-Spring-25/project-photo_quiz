class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    # all students in your courses
    @students = current_user
                  .owned_courses
                  .includes(:students)
                  .flat_map(&:students)
    total = @students.size

    mastered   = @students.count { |s| s.name_mastery >= 2 }
    learning   = @students.count { |s| s.name_mastery == 1 }
    unlearned  = @students.count { |s| s.name_mastery == 0 }

    if total.positive?
      @name_mastery2 = ( mastered.to_f  / total * 100 ).round(1)
      @name_mastery1 = ( learning.to_f  / total * 100 ).round(1)
      @name_mastery0 = ( unlearned.to_f / total * 100 ).round(1)
    else
      @name_mastery2 = @name_mastery1 = @name_mastery0 = 0
    end

    # ── overall progress: weighted by name_mastery (0,1,2) over max points ──
    sum_points = @students.sum(&:name_mastery)
    @overall_progress = total.positive? ?
      ( sum_points.to_f / ( total * 2 ) * 100 ).round(1) : 0


    # leaderboard: avg progress per professor (by email here)
    ranked = User
      .joins(owned_courses: :students)
      .select(
        "users.id, " \
        "users.email, " \
        "SUM(students.name_mastery) AS total_mastery"
      )
      .group("users.id", "users.email")      
      .order( Arel.sql("SUM(students.name_mastery) DESC") )    

    @top3      = ranked.limit(3)
    @others    = ranked.offset(3)
    @max_mastery = @top3.map(&:total_mastery).max.to_f
    all_ids        = ranked.pluck(:id)
    @user_rank     = all_ids.index(current_user.id)&.next
    @user_mastery  = ranked.find { |u| u.id == current_user.id }&.total_mastery || 0

    #####
    
    
    courses = current_user.owned_courses.includes(:students)
    if courses.any?
      # pick course with highest # of “learned” students
      most = courses.max_by { |c| c.students.count }
      least = courses.min_by { |c| c.students.count }

      @most_learnt_course        = most
      @most_learnt_learned_count = most.students.where(learned: true).count
      @most_learnt_learning_count= most.students.where(learned: false).count

      @least_learnt_course        = least
      @least_learnt_learned_count = least.students.where(learned: true).count
      @least_learnt_learning_count= least.students.where(learned: false).count
    else
      @most_learnt_course = @least_learnt_course = nil
      @most_learnt_learned_count = @least_learnt_learned_count = 0
      @most_learnt_learning_count = @least_learnt_learning_count = 0
    end
  end
end