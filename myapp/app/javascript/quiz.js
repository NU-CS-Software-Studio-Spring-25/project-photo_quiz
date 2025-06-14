console.log("quiz.js loaded");

document.addEventListener("DOMContentLoaded", () => {
  let questions = [], current = 0, results = [], mode = "check";
  const photoEl = document.getElementById("question-photo");
  const optsEl  = document.getElementById("options-container");
  const fbEl    = document.getElementById("feedback");
  const btnEl   = document.getElementById("action-btn");
  const quizContainer = document.getElementById("quiz-container");
  const startBtn = document.getElementById("start-quiz");
  const classSelect = document.getElementById("class-select");
  const progressEl = document.getElementById("progress");
  
  // Remove previous listeners if any (defensive, in case of hot reloads)
  startBtn.replaceWith(startBtn.cloneNode(true));
  btnEl.replaceWith(btnEl.cloneNode(true));
  optsEl.replaceWith(optsEl.cloneNode(true));

  // Re-select after cloning
  const newStartBtn = document.getElementById("start-quiz");
  const newBtnEl = document.getElementById("action-btn");
  const newOptsEl = document.getElementById("options-container");

  function getCsrfToken() {
    const token = document.querySelector('meta[name="csrf-token"]');
    return token ? token.content : null;
  }

  function normalize(s) {
    return s.toLowerCase().trim().replace(/\s+/g, " ");
  }

  // Add accessible aria-label for dynamically updated images
  function updatePhotoAccessibility(photoEl, description) {
    photoEl.setAttribute('aria-label', description || 'Quiz question image');
  }

  function renderQuestion() {
    const q = questions[current];
    // Show photo
    photoEl.style.backgroundImage = `url('${q.photo_url}')`;
    photoEl.classList.toggle("d-none", !q.photo_url);
    
    updatePhotoAccessibility(photoEl, q.photo_description); // Add accessibility

    // Render options
    if (q.type === "name") {
      newOptsEl.innerHTML = `
      <label for="text-answer" class="visually-hidden">Type your answer</label>
      <input id="text-answer" type="text"
            class="form-control mb-3 search-input"
            placeholder="Type name…"
            aria-describedby="name-help"
            aria-label="Student name"
            minlength="2"
            maxlength="50" />
      <small id="name-help" class="form-text text-muted">
        Enter student first name, last name, or both.
      </small>
      `;
    } else {
       newOptsEl.innerHTML = `
      <fieldset class="options-grid" role="radiogroup" aria-label="Answer choices">
        ${q.options.map((opt, i) => `
          <label class="option-box" for="answer-${i}">
            <input
              type="radio"
              name="answer"
              id="answer-${i}"
              value="${opt}"
              class="visually-hidden"
              aria-label="Option ${opt}"
            >
            <span class="option-text">${opt}</span>
          </label>
        `).join("")}
      </fieldset>`;
    }
  
    // Reset feedback/button/progress
    fbEl.textContent  = "";
    newBtnEl.textContent = "Check";
    newBtnEl.classList.remove("d-none");
    progressEl.textContent = `${current + 1} / ${questions.length}`;
    mode = "check";
  }
  

  // Start Quiz
  newStartBtn.addEventListener("click", () => {
    const course = classSelect.value;
    if (!course) return alert("Select a class first.");

    fetch(`/quizzes?course=${encodeURIComponent(course)}`)
      .then(r => r.json())
      .then(data => {
        if (data.error) {
          alert(data.error);
          quizContainer.classList.add("d-none");
          return;
        }
        // Shuffle array
        data.sort(() => Math.random() - 0.5);

        // Pick 25% to be name‐type
        const nameCount = Math.ceil(data.length * 0.25);
        const nameIdxs  = new Set();
        while (nameIdxs.size < nameCount) {
          nameIdxs.add(Math.floor(Math.random() * data.length));
        }

        // Annotate each question with a type
        questions = data.map((q, i) => ({
          ...q,
          type: (nameIdxs.has(i) && q.correct_name) ? "name" : "mcq"
        }));

        questions.forEach(q => {
          if (q.type === "mcq") {
            const opts = new Set(q.options);
            opts.add(q.correct_name);                      // ensure correct is present
            q.options = Array.from(opts)
                            .sort(() => Math.random() - 0.5);
            
          }
        });

        if (questions.length === 0) {
          alert("No quiz questions available for this course.");
          quizContainer.classList.add("d-none");
          return;
        }

        current = 0;
        results = [];
        quizContainer.classList.remove("d-none");
        photoEl.classList.remove("d-none");
        newBtnEl.classList.remove("d-none");
        renderQuestion();
      })
      .catch(() => {
        alert("Could not load quiz.");
        quizContainer.classList.add("d-none");
      });
  });

  // Delegate clicks on option-boxes to toggle “selected” class
  newOptsEl.addEventListener("click", e => {
    const box = e.target.closest(".option-box");
    if (box) {
      // unselect others
      newOptsEl.querySelectorAll(".option-box").forEach(b => b.classList.remove("selected"));
      box.classList.add("selected");
      box.querySelector("input").checked = true;
    }
  });

  // Check/Next Button
  newBtnEl.addEventListener("click", () => {
    const q = questions[current];
    let ok = false;
    if (mode === "check") {
      if (q.type === "name") {
        const input = document.getElementById("text-answer");
        const ansRaw = input.value;
        const ans     = ansRaw.trim();

        if (!ans) return alert("Please type an answer.");

        const norm        = normalize(ans);
        const correctNorm = normalize(q.correct_name);
        ok = (norm === correctNorm) ||
             (norm === correctNorm.split(" ")[0]);

        input.classList.remove("correct", "incorrect");
        input.classList.add(ok ? "correct" : "incorrect");

      } else if (Array.isArray(q.options)) {
        const sel = newOptsEl.querySelector("input[name='answer']:checked");
        if (!sel) return alert("Please pick an answer.");

        const selNorm     = normalize(sel.value);
        const correctNorm = normalize(q.correct_name);
        ok = (selNorm === correctNorm);

        const selBox = sel.closest(".option-box");
        if (ok) {
          selBox.classList.add("correct");
        } else {
          selBox.classList.add("incorrect");
          // highlight the true one
          const correctBox = Array.from(
            newOptsEl.querySelectorAll(".option-box")
          ).find(box =>
            normalize(box.querySelector(".option-text").textContent) === correctNorm
          );
          if (correctBox) correctBox.classList.add("correct");
        }
      }
     }

     if (mode === "check") {
      if (q.type === "name") {
        fbEl.innerHTML = ok ? "✅ Correct!" : `❌ Sorry, wrong. Correct answer is: <b>${q.correct_name}</b>`;
      }
      else {
        fbEl.textContent = ok ? "✅ Correct!" : "❌ Sorry, wrong.";
      }
       results.push(ok);
       if (ok && q.student_id) { // Only if correct and student_id is available
         fetch('/quizzes/record_answer', {
           method: 'POST',
           headers: {
             'Content-Type': 'application/json',
             'X-CSRF-Token': getCsrfToken() // Send CSRF token
           },
           body: JSON.stringify({
             student_id: q.student_id,
             course_id: classSelect.value, // For context if needed by backend later
             correct: true // 'ok' variable already confirms this
           })
         })
         .then(response => response.json())
         .then(data => {
           console.log('Answer recorded:', data);
         })
         .catch(err => {
           console.error('Failed to record answer:', err);
         });
       }
       newBtnEl.textContent = "Next";
       mode = "next";
     } else {
       current++;
       if (current < questions.length) {
         renderQuestion();
       } else {
        const correctCount = results.filter(Boolean).length;
        const totalCount = questions.length;
        const courseId = classSelect.value; 
        window.location.href = `/quizzes/results?course_id=${encodeURIComponent(courseId)}&correct=${correctCount}&total=${totalCount}`;
       }
     }
   });

  // Adding landmarks for accessibility

  // Wrap the quiz container in a <main> landmark
  const mainEl = document.createElement("main");
  mainEl.setAttribute("role", "main");
  mainEl.setAttribute("aria-labelledby", "quiz-title");
  quizContainer.parentNode.insertBefore(mainEl, quizContainer);
  mainEl.appendChild(quizContainer);

  // Add an <h1> for the quiz title if not already present
  if (!document.getElementById("quiz-title")) {
    const quizTitle = document.createElement("h1");
    quizTitle.id = "quiz-title";
    quizTitle.textContent = "Photo Quiz"; // Adjust title as needed
    mainEl.insertBefore(quizTitle, quizContainer);
  }

  // Ensure feedback section has an appropriate role
  fbEl.setAttribute("role", "status");
  fbEl.setAttribute("aria-live", "polite");

  // Ensure options container has a role of group
  optsEl.setAttribute("role", "group");
  optsEl.setAttribute("aria-labelledby", "options-label");

  // Add a visually hidden label for options if not present
  if (!document.getElementById("options-label")) {
    const optionsLabel = document.createElement("span");
    optionsLabel.id = "options-label";
    optionsLabel.textContent = "Answer options";
    optionsLabel.classList.add("visually-hidden");
    optsEl.parentNode.insertBefore(optionsLabel, optsEl);
  }
  });