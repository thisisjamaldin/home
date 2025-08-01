// ----------------------------------------
// script.js (updated to prevent “garbled” typewriter when switching fast)
// ----------------------------------------

// 1. All text keys and translations:
const translations = {
  // Navbar
  "nav.home":       { en: "Home",          ru: "Главная" },
  "nav.about":      { en: "About me",      ru: "Обо мне" },
  "nav.projects":   { en: "Projects",      ru: "Проекты" },
  "nav.contact":    { en: "Contacts",      ru: "Контакты" },

  // Home (typing effect)
  "home.title":     { en: "Flutter developer", 
                      ru: "Разработчик Flutter" },
  "home.subtitle":  { en: "Hi! I'm Jamaldin. A passionate Flutter developer based in Kyrgyzstan",
                      ru: "Привет! Я Жамалдин. Увлечённый разработчик Flutter из Кыргызстана" },

  // Tech section
  "tech.title":     { en: "Tech Stack",    ru: "Технологии" },

  // About section
  "about.heading":  { en: "About me",      ru: "Обо мне" },
  "about.title":    { en: "As a self-taught programmer,",    
                      ru: "Самоучка-программист," },
  "about.description": {
    en: "who first started creating games in Unity C# and then switched to Django to create his own Rest API to interact with Android apps. He started getting interested in developing Android apps and graduated an Android development course <a href='https://geeks.kg' target='_blank'>Geeks</a> which taught him Android Studio. As other developers he tried to make an app and start a startup; after finishing the Android version he realized he also needed an iOS version and began learning Swift in the process of developing his app. Then he found a job as a Flutter developer and understood that Flutter can replace native development once he saw popular apps and how devices were becoming faster.",
    ru: "сначала создавал игры на Unity C#, затем перешёл на Django, чтобы создать собственный REST API для взаимодействия с Android-приложениями. Увлёкся разработкой Android-приложений и окончил курс Android-разработки <a href='https://geeks.kg' target='_blank'>Geeks</a>, где учили Android Studio. Как и многие, решил сделать приложение и запустить стартап; после выпуска Android-версии понял, что нужна iOS-версия, и начал изучать Swift прямо в процессе разработки. Затем устроился Flutter-разработчиком и убедился, что Flutter может заменить нативную разработку, когда увидел популярные приложения и рост производительности устройств."
  },

  // Projects section
  "projects.heading": { en: "Projects",     ru: "Проекты" },

  // Project #1: Cella
  "project1.desc":   {
    en: "This app is a digital tool that helps individuals and businesses manage their financial records and perform various accounting tasks. It is typically designed for use on smartphones.",
    ru: "Это приложение ‒ цифровой инструмент, помогающий людям и компаниям вести финансовую отчётность и выполнять различные бухгалтерские задачи. Оно сделано для смартфонов."
  },
  "project1.date":   { en: "Oct 26, 2024",  ru: "26 окт 2024 г." },

  // Project #2: Jerdesh Moskva
  "project2.desc":   {
    en: "Jerdesh Moskva – a convenient assistant for job search and ads. Quickly find vacancies, real estate and services with a simple interface and handy filters.",
    ru: "Jerdesh Moskva – удобный помощник для поиска работы и объявлений. Быстро находите вакансии, недвижимость и услуги через простой интерфейс и удобные фильтры."
  },
  "project2.date":   { en: "Apr 11, 2025",  ru: "11 апр 2025 г." },

  // Project #3: Intex Cargo
  "project3.desc":   {
    en: "Intex Cargo is a modern application for managing cargo transportation and logistics. Simplify your work with orders and control transportation in a few clicks.",
    ru: "Intex Cargo – современное приложение для управления грузоперевозками и логистикой. Упростите работу с заказами и контролируйте перевозки в пару кликов."
  },
  "project3.date":   { en: "Mar 6, 2025",   ru: "6 мар 2025 г." },

  // Contact section
  "contact.heading": { en: "Contacts",      ru: "Контакты" },
  "contact.email":   { en: "thisisjoma@gmail.com",  ru: "thisisjoma@gmail.com" }, 
  "contact.telegram":{ en: "@thisisjamaldin",      ru: "@thisisjamaldin" },

  // Footer
  "footer.copyright": {
    en: "Copyright © 2023-2025. All rights are reserved",
    ru: "Авторские права © 2023–2025. Все права защищены"
  }
};

// 2. Track any running timeouts so we can clear them if user switches languages quickly
let typewriterTimers = [];

/**
 * Clears all pending timeouts saved in typewriterTimers,
 * then resets the array so we can start fresh.
 */
function clearTypewriterTimers() {
  typewriterTimers.forEach(timerID => clearTimeout(timerID));
  typewriterTimers = [];
}

// 3. “Typewriter” effect that pushes each timeout ID into typewriterTimers
function typeWriter(p, fullText, p1, fullText2) {
  // Ensure no leftover characters
  p.innerText = "";
  if (p1) p1.innerText = "";

  let i = 0;
  function go() {
    if (i < fullText.length) {
      p.innerHTML += fullText.charAt(i);
      i++;
      // Save timer ID
      typewriterTimers.push(
        setTimeout(go, 40)
      );
    } else if (p1) {
      // Slight delay before typing second line
      let delayTimer = setTimeout(() => {
        let j = 0;
        function go2() {
          if (j < fullText2.length) {
            p1.innerHTML += fullText2.charAt(j);
            j++;
            typewriterTimers.push(
              setTimeout(go2, 40)
            );
          }
        }
        go2();
      }, 200);
      typewriterTimers.push(delayTimer);
    }
  }
  go();
}

// 4. Populate every element with data-i18n-key based on currentLang
let currentLang = "en";
const userLang = navigator.language || navigator.userLanguage;
if (userLang.toLowerCase().startsWith("ru")) {
  currentLang = "ru";
}
function translateAll() {
  // 4a. Before we re‐type, clear any pending timeouts from a previous animation
  clearTypewriterTimers();

  // 4b. Replace all static text nodes
  document.querySelectorAll("[data-i18n-key]").forEach(el => {
    const key = el.getAttribute("data-i18n-key");
    const entry = translations[key];
    if (entry && entry[currentLang] !== undefined) {
      el.innerHTML = entry[currentLang];
    }
  });

  // 4c. Now handle the “typing effect” for the home section
  const homeTitleEl = document.getElementById("home_main_text");
  const homeInfoEl  = document.getElementById("home_main_info");
  const text1 = translations["home.title"][currentLang];
  const text2 = translations["home.subtitle"][currentLang];

  typeWriter(homeTitleEl, text1, homeInfoEl, text2);
}

// 5. On DOMContentLoaded, set up the language‐switcher pills and do the first translation
window.addEventListener("DOMContentLoaded", () => {
  // 5a. Mark the correct pill as “active”
  document.querySelectorAll(".lang-btn").forEach(btn => {
    if (btn.dataset.lang === currentLang) {
      btn.classList.add("active");
    } else {
      btn.classList.remove("active");
    }

    // 5b. Whenever a user clicks EN or RU:
    btn.addEventListener("click", () => {
      const chosen = btn.dataset.lang;
      if (chosen === currentLang) return; // no change
      currentLang = chosen;
      localStorage.setItem("preferredLang", currentLang);

      // Update the pill UI
      document.querySelectorAll(".lang-btn").forEach(b => {
        b.classList.toggle("active", b.dataset.lang === currentLang);
      });

      // And re‐translate everything (will also restart the typewriter, but safely)
      translateAll();
    });
  });

  // 5c. If you want to persist between sessions, override with localStorage
  const stored = localStorage.getItem("preferredLang");
  if (stored && (stored === "en" || stored === "ru")) {
    currentLang = stored;
    // Make sure UI reflects it
    document.querySelectorAll(".lang-btn").forEach(b => {
      b.classList.toggle("active", b.dataset.lang === currentLang);
    });
  }

  // 5d. Run the very first translation pass
  translateAll();
});

// 6. The existing “blob” animation & reveal‐on‐scroll can remain unchanged:
const img = document.getElementById('self');
const img_container = document.getElementById('self_container');
const effect_section = document.querySelectorAll(".effect");

function getRan(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function anim() {
  img_container.style.borderRadius =
    `${getRan(30, 50)}% ${getRan(30, 50)}% ${getRan(30, 50)}% ${getRan(30, 50)}%`;
  let ran = Math.floor(Math.random() * 201) - 100;
  img_container.style.transform = 'rotate(' + ran + 'deg)';
  img.style.transform = 'rotate(' + ran * -1 + 'deg)';
}
setInterval(anim, 500);

function reveal() {
  effect_section.forEach(section => {
    const windowHeight = window.innerHeight;
    const elementTop = section.getBoundingClientRect().top;
    if (elementTop < windowHeight) {
      section.classList.add("active");
    } else {
      section.classList.remove("active");
    }
  });
}
window.addEventListener("scroll", reveal);
