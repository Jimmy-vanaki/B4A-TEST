function search(query) {
  //update search and highlight new matched word
  $(".book_text").each(function () {
    var $this = $(this);
    var checkString = $this.text();
    var start = $this.text().toLowerCase().indexOf(query);
    var end = query.slice().length;
    var matchWord = checkString.substring(start, start + end);

    if (checkString.toLowerCase().match(query)) {
      $this.html(
        checkString.replace(
          matchWord,
          '<span class="mark">' + matchWord + "</span>"
        )
      );
    }
  });
}

/* make new range */
let currentPage = 0;
let custom_slider = document.getElementById("custom_range");

document.querySelectorAll(".slider").forEach((elem) => {
  let slider = noUiSlider.create(elem, {
    start: 1,
    tooltips: true,
    connect: "lower",
    orientation: "vertical",
    range: {
      min: 1,
      max: 100,
    },
    format: wNumb({
      decimals: 0,
    }),
  });

  elem.noUiSlider.on("change", (params) => {
    // if(currentPage != (elem.noUiSlider.get()-1)) {
    currentPage = elem.noUiSlider.get() - 1;
    window.scrollTo(0, 0);
    let y = getOffset(document.getElementById("book-mark_" + currentPage)).top;
    window.scrollTo(0, y);
    // }
  });
});
// let app = (() => {
//   function updateSlider(element) {
//     if (element) {
//       var max = document.getElementById("my-range").max;

//       let parent = element.parentElement,
//         lastValue = parent.getAttribute("data-slider-value");

//       if (lastValue === element.value) {
//         return; // No value change, no need to update then
//       }

//       parent.setAttribute("data-slider-value", element.value);
//       let $thumb = parent.querySelector(".range-slider__thumb"),
//         $bar = parent.querySelector(".range-slider__bar"),
//         pct =
//           (element.value *
//             ((parent.clientHeight - $thumb.clientHeight) /
//               parent.clientHeight)) /
//           (max / 100);

//       $thumb.style.bottom = `${pct}%`;
//       $bar.style.height = `calc(${pct}% + ${$thumb.clientHeight / 2}px)`;
//       $thumb.textContent = `${element.value}`;
//     }
//   }
//   return {
//     updateSlider: updateSlider,

//   };
// })();

function ChangeSliderPage() {
  input = document.querySelector("#my-slider");
  $(document).on("input", "#my-slider", function () {
    console.log($(this).val);
    alert("aer");
    window.scrollTo(0, 0);
    var y = getOffset(
      document.getElementById("book-mark_" + ($(this).val() - 1))
    ).top;
    window.scrollTo(0, y);
  });
}

// 	initAndSetupTheSliders(1);
// function initAndSetupTheSliders(Val) {
//   const inputs = [].slice.call(
//     document.querySelectorAll(".range-slider input")
//   );
//   inputs.forEach((input) => input.setAttribute("value", Val));
//   inputs.forEach((input) => app.updateSlider(input));
//   inputs.forEach((input) =>
//     input.addEventListener("input", (element) => app.updateSlider(input))
//   );
//   inputs.forEach((input) =>
//     input.addEventListener("change", (element) => app.updateSlider(input))
//   );
// };

// SET BOOKPAGE FONTTYPE
let p_font = $(".book-page > div");

function clear_classfont(p_font) {
  p_font.removeAttr("class");
}
$(".radio-btn").each(function (index, value) {
  $(this).click(() => {
    let p_font = $(".book-page > div");
    clear_classfont(p_font);
    switch (index) {
      case 0:
        p_font.addClass("Lotus-Light");
        break;
      case 1:
        p_font.addClass("NotoNaskhArabic");

        break;
      case 2:
        p_font.addClass("DIJALHRegular");
    }
  });
});

/*var postBoxes = document.querySelectorAll(".book-mark");
postBoxes.forEach(function (postBox) {
  postBox.addEventListener("click", function () {
    let item = document.getElementById(postBox.id);
    if (item.classList.contains("add_fav")) {
      item.classList.remove("add_fav");
    } else {
      item.classList.add("add_fav");
    }
    // console.log(id);
  });
});*/

function getOffset(el) {
  var _x = 0;
  var _y = 0;
  while (el && !isNaN(el.offsetLeft) && !isNaN(el.offsetTop)) {
    _x += el.offsetLeft - el.scrollLeft;
    _y += el.offsetTop - el.scrollTop;
    el = el.offsetParent;
  }
  return { top: _y, left: _x };
}

//  SET BACK-GROUND

function clear_classbg() {
  btn_bg.removeClass("bg-active");
  btn_bg.removeClass("animate__jello");
  $(".checked").css("opacity", "0");
}

function Close_Setting() {
  $(".overlay-setting").click(function (event) {
    const btn = $(".setting-Collapse");
    if (!btn.is(event.target) && !btn.has(event.target).length) {
      $(".overlay-setting").removeClass("show_setting");
    }
  });
}

if ($("#page-input").length > 0) {
  const sliderValue = document.getElementById("page-value");
  const inputSlider = document.getElementById("page-input");
  inputSlider.oninput = () => {
    console.log(inputSlider.max);
    let value = inputSlider.value;
    sliderValue.textContent = value;

    sliderValue.style.right = 400 * (value / inputSlider.max) + "px";
    sliderValue.classList.add("show");
  };
  inputSlider.onblur = () => {
    sliderValue.classList.remove("show");
  };

  $("#page-input").on("change", function () {
    var value = document.getElementById("page-input").value;

    console.log(value);
  });
}
