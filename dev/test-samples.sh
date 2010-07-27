cat sample.fr | apertium fr-pt > sample.fr-pt
cat sample.pt | apertium pt-fr > sample.pt-fr
cat sample.fr | apertium -d .. fr-pt-tagger > sample.fr-tagged
cat sample.pt | apertium -d .. pt-fr-tagger > sample.pt-tagged
