class StudentMailer < ApplicationMailer
    default from: ENV["GMAIL_USERNAME"]

    def new_student_notification(student, user, course)
        @student = student
        @user = user
        @course = course
        mail(
            to: @user.email,
            subject: "New student added to your course: #{@course.name}"
        )
    end
end
