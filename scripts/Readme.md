`anim_cjk_convert` can be used to convert svgs like [this one](https://github.com/parsimonhi/animCJK/blob/master/svgsJa/11904.svg) into format usable by my swift code.   
Usage example:
```bash
# from anim_cjk_convert folder
# outputs converted data to stdout
go run . --input 31169.svg
# convert a bunch of files at once
for u in `ls ~/repos/animCJK/svgsJa/`; do go run . --input ~/repos/animCJK/svgsJa/$u >> kanji.json; done
```   
For example, [kanji.json](../data/japanese/kanji.json) file was created like this.   

`svg_convert` is used to convert one-off svgs into something usable by my swift code. It takes svgs produced by apps like Adobe Illustrator, which employ dense packing techniques, and normalizes them to be consumable by the first script. Example: `m34.98,35.98c-1.74.51-3.84.72-6.08.82` -> `M 34.98 35.98 C 33.24 36.49 31.14 36.70 28.90 36.80`   

Hindi letters [hi.json](../data/hindi/hi.json) were created and converted like that: I took an open-source svg of a font, drawn medians (used for animation and stroke tracing) myself in Adobe, then converted generated packed svg format into an extended form.