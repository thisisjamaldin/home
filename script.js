const img = document.getElementById('self')
const img_container = document.getElementById('self_container')
const main_text = document.getElementById("home_main_text")
const main_info = document.getElementById("home_main_info")
const effect_section = document.querySelectorAll(".effect")

function typeWriter(p, p_text, p1, p1_text) {
    let i = 0
    function go() {
        if (i < p_text.length) {
            p.innerHTML += p_text.charAt(i);
            i++;
            setTimeout(go, 40);
        } else {
            if (p1 != undefined) {
                typeWriter(p1, p1_text)
            }
        }
    }
    go()
}

typeWriter(main_text, "Android developer", main_info, "Hi! I'm Jamaldin. A passionate Android developer based in Kyrgyzstan")


function getRan(min, max) {
    return Math.floor(Math.random() * (max-min+1)) + min
}

function anim() {
    img_container.style.borderRadius = `${getRan(30, 50)}% ${getRan(30, 50)}% ${getRan(30, 50)}% ${getRan(30, 50)}%`
    let ran = Math.floor(Math.random() * 201) - 100;
    img_container.style.transform = 'rotate('+ran+'deg)';
    img.style.transform = 'rotate('+ran*-1+'deg)';
}

setInterval(anim, 500)

function reveal() {
    for (let i = 0; i < effect_section.length; i++) {
        var windowHeight = window.innerHeight;
        var elementTop = effect_section[i].getBoundingClientRect().top;

        if (elementTop < windowHeight) {
            effect_section[i].classList.add("active");
        } else {
            effect_section[i].classList.remove("active");
        }
    }
}

window.addEventListener("scroll", reveal);