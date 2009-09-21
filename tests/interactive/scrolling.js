/* -*- mode: js2; js2-basic-offset: 4; indent-tabs-mode: nil -*- */

const Clutter = imports.gi.Clutter;
const Nbtk = imports.gi.Nbtk;

const UI = imports.testcommon.ui;

UI.init();
let stage = Clutter.Stage.get_default();

let vbox = new Nbtk.BoxLayout({ vertical: true,
                                width: stage.width,
                                height: stage.height,
                                style: "padding: 10px;" });
stage.add_actor(vbox);

let v = new Nbtk.ScrollView();
vbox.add(v, { expand: true });

let b = new Nbtk.BoxLayout({ vertical: true,
                             style: "border: 2px solid #880000; border-radius: 10px; padding: 0px 5px;" });
v.add_actor(b);

let cc_a = "a".charCodeAt(0);
let s = "";
for (let i = 0; i < 26 * 3; i++) {
    s += String.fromCharCode(cc_a + i % 26);

    let t = new Nbtk.Label({ text: s,
                             reactive: true });
    let line = i + 1;
    t.connect('button-press-event',
              function() {
                  log("Click on line " + line);
              });
    b.add(t);
}

stage.show();
Clutter.main();
stage.destroy();
