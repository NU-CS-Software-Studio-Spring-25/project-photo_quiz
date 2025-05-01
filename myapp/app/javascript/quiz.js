document.addEventListener("DOMContentLoaded", () => {
    let questions = [], current = 0, results = [];
  
    // Start Quiz Button
    document.getElementById("start-quiz").addEventListener("click", () => {
      const course = document.getElementById("class-select").value;
      if (!course) return alert("Select a class first.");
  
      // Fetch quiz data
      fetch(`/quizzes?course=${encodeURIComponent(course)}`)
        .then(res => res.json())
        .then(data => {
          questions = data;
          current = 0;
          results = [];
          document.getElementById("quiz-container").style.display = "block";
          showQuestion();
        })
        .catch(() => alert("Could not load quiz."));
    });
  
    // Show Question
    function showQuestion() {
      const q = questions[current];
      document.getElementById("question-photo").style.background =
        `#EDE0F7 url('${q.photo_url}') center/cover`;
      const opts = document.getElementById("options-container");
      opts.innerHTML = "";
      q.options.forEach((opt, i) => {
        opts.insertAdjacentHTML("beforeend", `
          <div class="form-check">
            <input class="form-check-input" type="radio" name="answer"
                   id="opt${i}" value="${opt}">
            <label class="form-check-label" for="opt${i}">${opt}</label>
          </div>`);
      });
    }
  
    // Next Question Button
    document.getElementById("next-question").addEventListener("click", () => {
      const sel = document.querySelector("input[name='answer']:checked");
      if (!sel) return;
      results.push(sel.value === questions[current].correct_name);
      current++;
      if (current < questions.length) {
        showQuestion();
      } else {
        alert(`Score: ${results.filter(Boolean).length} / ${questions.length}`);
        document.getElementById("quiz-container").style.display = "none";
      }
    });
  });