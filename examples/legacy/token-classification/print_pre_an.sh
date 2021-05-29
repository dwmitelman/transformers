#!/bin/bash

export MAIN_DIR=/home/cs08/DanielAnat/GitProjects/transformers/examples/legacy/token-classification

languages=(
  # Indu-European - West Germanic
  EN  # English
  DE  # German
  NL  # Dutch
  AF  # Afrikaans

  # Indu-European - Latin
  ES  # Spanish
  PT  # Portugese
  FR  # French
  CA  # Catalan
  IT  # Italian
  GL  # Galician

  # Indu-European - Slavic East
  RU  # Russian
  UK  # Ukrainian
  BE  # Belarusian

  # Indu-European - Slavic West
  PL  # Polish
  CS  # Czech
  SK  # Slovak
  RO  # Romanian

  # Indu-European - Slavic South
  BG  # Bulgarian
  HR  # Croatian
  SR  # Serbian

  # Baltic
  LT  # Lithuanian
  LV  # Latvian

  # Uralic
  HU  # Hungarian
  FI  # Finnish
  ET  # Estonian

  # North Germanic
  IS  # Icelandic
  FO  # Faroese
  NO  # Norwegian
  DA  # Danish
  SV  # Swedih

  # Celtic
  GD  # Scottish Gaelic
  CY  # Welsh
  GA  # Irish

  # Iranian
  FA  # Persian

  # Indu-Aryan
  HI  # Hindi
  UR  # Urdu

  # Semitic
  HE  # Hebrew
  AR  # Arabic
  MT  # Maltese
)

cd $MAIN_DIR #0
#echo "0 Moved to dir: `pwd`"

for language_from in "${languages[@]}"; do

  if [ -d $language_from ]; then
    cd $language_from #1
    #echo "Moved to dir: `pwd`"

    for language_to in "${languages[@]}"; do
      if [ -d $language_to ]; then
        cd $language_to #2
        # echo "Moved to dir: `pwd`"
        prerun_dir="output-${language_from}-${language_to}"

        cd $prerun_dir #3
        echo ${language_from}-${language_to} `cat test_results.txt | grep test_f1`
        cd ../ #3
        cd ../ #2

      fi
    done

    cd ../ #1
  fi
done
