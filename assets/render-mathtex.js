let inline = document.querySelectorAll("a[href='/$/']");
for (let i=inline.length-1; i>=0; i--) {
    let src =  inline[i].textContent;
    inline[i].outerHTML = temml.renderToString(src, { displayMode: false });
}

let eqns = document.querySelectorAll("script[type='math/tex']");
for (let i=eqns.length-1; i>=0; i--) {
    let eqn = eqns[i];
    let src = eqn.text;
    let d = eqn.closest('p') == null; 
    eqn.outerHTML = temml.renderToString(src, { displayMode: d });
}
