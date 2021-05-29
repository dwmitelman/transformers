#!/bin/bash

export MAX_LENGTH=128
export OUTPUT_DIR=postagger-model
export TRAINED_DIR=postagger-model-copy
export BATCH_SIZE=32
export NUM_EPOCHS=3
export SAVE_STEPS=100000
export SEED=1
export BERT_MODEL=bert-base-multilingual-cased
export MAIN_DIR=/home/cs08/DanielAnat/GitProjects/transformers/examples/legacy/token-classification

echo START_RUNING

languages_run=(
  EN
  DE
  NL
  AF
  ES
  PT
  FR
  CA
  IT
  GL

  RU
  UK
  BE
  PL
  CS
  SK
  RO
  BG
  HR
  SR

  LT
  LV
  HU
  FI
  ET
  IS
  FO
  NO
  DA
  SV

  GD
  CY
  GA
  FA
  HI
  UR
  HE
  AR
  MT
)

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

declare -A pairs_train=(
  [EN]="https://raw.githubusercontent.com/UniversalDependencies/UD_English-EWT/master/en_ewt-ud-train.conllu"
  [DE]="https://raw.githubusercontent.com/UniversalDependencies/UD_German-GSD/master/de_gsd-ud-train.conllu"
  [NL]="https://raw.githubusercontent.com/UniversalDependencies/UD_Dutch-Alpino/master/nl_alpino-ud-train.conllu"
  [ES]="https://raw.githubusercontent.com/UniversalDependencies/UD_Spanish-AnCora/master/es_ancora-ud-train.conllu"
  [PT]="https://raw.githubusercontent.com/UniversalDependencies/UD_Portuguese-GSD/master/pt_gsd-ud-train.conllu"
  [FR]="https://raw.githubusercontent.com/UniversalDependencies/UD_French-GSD/master/fr_gsd-ud-train.conllu"
  [PL]="https://raw.githubusercontent.com/UniversalDependencies/UD_Polish-PDB/master/pl_pdb-ud-train.conllu"
  [HU]="https://raw.githubusercontent.com/UniversalDependencies/UD_Hungarian-Szeged/master/hu_szeged-ud-train.conllu"
  [FI]="https://raw.githubusercontent.com/UniversalDependencies/UD_Finnish-FTB/master/fi_ftb-ud-train.conllu"
  [ET]="https://raw.githubusercontent.com/UniversalDependencies/UD_Estonian-EDT/master/et_edt-ud-train.conllu"
  [RU]="https://raw.githubusercontent.com/UniversalDependencies/UD_Russian-GSD/master/ru_gsd-ud-train.conllu"
  [UK]="https://raw.githubusercontent.com/UniversalDependencies/UD_Ukrainian-IU/master/uk_iu-ud-train.conllu"
  [BE]="https://raw.githubusercontent.com/UniversalDependencies/UD_Belarusian-HSE/master/be_hse-ud-train.conllu"
  [CS]="https://raw.githubusercontent.com/UniversalDependencies/UD_Czech-CAC/master/cs_cac-ud-train.conllu"
  [SK]="https://raw.githubusercontent.com/UniversalDependencies/UD_Slovak-SNK/master/sk_snk-ud-train.conllu"
  [BG]="https://raw.githubusercontent.com/UniversalDependencies/UD_Bulgarian-BTB/master/bg_btb-ud-train.conllu"
  [HR]="https://raw.githubusercontent.com/UniversalDependencies/UD_Croatian-SET/master/hr_set-ud-train.conllu"
  [SR]="https://raw.githubusercontent.com/UniversalDependencies/UD_Serbian-SET/master/sr_set-ud-train.conllu"
  [LT]="https://raw.githubusercontent.com/UniversalDependencies/UD_Lithuanian-ALKSNIS/master/lt_alksnis-ud-train.conllu"
  [LV]="https://raw.githubusercontent.com/UniversalDependencies/UD_Latvian-LVTB/master/lv_lvtb-ud-train.conllu"
  [IS]="https://raw.githubusercontent.com/UniversalDependencies/UD_Icelandic-Modern/master/is_modern-ud-train.conllu"
  [FO]="https://raw.githubusercontent.com/UniversalDependencies/UD_Faroese-FarPaHC/master/fo_farpahc-ud-train.conllu"
  [NO]="https://raw.githubusercontent.com/UniversalDependencies/UD_Norwegian-Bokmaal/master/no_bokmaal-ud-train.conllu"
  [DA]="https://raw.githubusercontent.com/UniversalDependencies/UD_Danish-DDT/master/da_ddt-ud-train.conllu"
  [SV]="https://raw.githubusercontent.com/UniversalDependencies/UD_Swedish-LinES/master/sv_lines-ud-train.conllu"
  [GD]="https://raw.githubusercontent.com/UniversalDependencies/UD_Scottish_Gaelic-ARCOSG/master/gd_arcosg-ud-train.conllu"
  [GA]="https://raw.githubusercontent.com/UniversalDependencies/UD_Irish-IDT/master/ga_idt-ud-train.conllu"
  [CY]="https://raw.githubusercontent.com/UniversalDependencies/UD_Welsh-CCG/master/cy_ccg-ud-train.conllu"
  [RO]="https://raw.githubusercontent.com/UniversalDependencies/UD_Romanian-RRT/master/ro_rrt-ud-train.conllu"
  [CA]="https://raw.githubusercontent.com/UniversalDependencies/UD_Catalan-AnCora/master/ca_ancora-ud-train.conllu"
  [IT]="https://raw.githubusercontent.com/UniversalDependencies/UD_Italian-ISDT/master/it_isdt-ud-train.conllu"
  [HI]="https://raw.githubusercontent.com/UniversalDependencies/UD_Hindi-HDTB/master/hi_hdtb-ud-train.conllu"
  [UR]="https://raw.githubusercontent.com/UniversalDependencies/UD_Urdu-UDTB/master/ur_udtb-ud-train.conllu"
  [FA]="https://raw.githubusercontent.com/UniversalDependencies/UD_Persian-Seraji/master/fa_seraji-ud-train.conllu"
  [GL]="https://raw.githubusercontent.com/UniversalDependencies/UD_Galician-CTG/master/gl_ctg-ud-train.conllu"
  [AF]="https://raw.githubusercontent.com/UniversalDependencies/UD_Afrikaans-AfriBooms/master/af_afribooms-ud-train.conllu"
  [HE]="https://raw.githubusercontent.com/UniversalDependencies/UD_Hebrew-HTB/master/he_htb-ud-train.conllu"
  [AR]="https://raw.githubusercontent.com/UniversalDependencies/UD_Arabic-PADT/master/ar_padt-ud-train.conllu"
  [MT]="https://raw.githubusercontent.com/UniversalDependencies/UD_Maltese-MUDT/master/mt_mudt-ud-train.conllu"
)

declare -A pairs_test=(
  [EN]="https://raw.githubusercontent.com/UniversalDependencies/UD_English-EWT/master/en_ewt-ud-test.conllu"
  [DE]="https://raw.githubusercontent.com/UniversalDependencies/UD_German-GSD/master/de_gsd-ud-test.conllu"
  [NL]="https://raw.githubusercontent.com/UniversalDependencies/UD_Dutch-Alpino/master/nl_alpino-ud-test.conllu"
  [ES]="https://raw.githubusercontent.com/UniversalDependencies/UD_Spanish-AnCora/master/es_ancora-ud-test.conllu"
  [PT]="https://raw.githubusercontent.com/UniversalDependencies/UD_Portuguese-GSD/master/pt_gsd-ud-test.conllu"
  [FR]="https://raw.githubusercontent.com/UniversalDependencies/UD_French-GSD/master/fr_gsd-ud-test.conllu"
  [PL]="https://raw.githubusercontent.com/UniversalDependencies/UD_Polish-PDB/master/pl_pdb-ud-test.conllu"
  [HU]="https://raw.githubusercontent.com/UniversalDependencies/UD_Hungarian-Szeged/master/hu_szeged-ud-test.conllu"
  [FI]="https://raw.githubusercontent.com/UniversalDependencies/UD_Finnish-FTB/master/fi_ftb-ud-test.conllu"
  [ET]="https://raw.githubusercontent.com/UniversalDependencies/UD_Estonian-EDT/master/et_edt-ud-test.conllu"
  [RU]="https://raw.githubusercontent.com/UniversalDependencies/UD_Russian-GSD/master/ru_gsd-ud-test.conllu"
  [UK]="https://raw.githubusercontent.com/UniversalDependencies/UD_Ukrainian-IU/master/uk_iu-ud-test.conllu"
  [BE]="https://raw.githubusercontent.com/UniversalDependencies/UD_Belarusian-HSE/master/be_hse-ud-test.conllu"
  [CS]="https://raw.githubusercontent.com/UniversalDependencies/UD_Czech-CAC/master/cs_cac-ud-test.conllu"
  [SK]="https://raw.githubusercontent.com/UniversalDependencies/UD_Slovak-SNK/master/sk_snk-ud-test.conllu"
  [BG]="https://raw.githubusercontent.com/UniversalDependencies/UD_Bulgarian-BTB/master/bg_btb-ud-test.conllu"
  [HR]="https://raw.githubusercontent.com/UniversalDependencies/UD_Croatian-SET/master/hr_set-ud-test.conllu"
  [SR]="https://raw.githubusercontent.com/UniversalDependencies/UD_Serbian-SET/master/sr_set-ud-test.conllu"
  [LT]="https://raw.githubusercontent.com/UniversalDependencies/UD_Lithuanian-ALKSNIS/master/lt_alksnis-ud-test.conllu"
  [LV]="https://raw.githubusercontent.com/UniversalDependencies/UD_Latvian-LVTB/master/lv_lvtb-ud-test.conllu"
  [IS]="https://raw.githubusercontent.com/UniversalDependencies/UD_Icelandic-Modern/master/is_modern-ud-test.conllu"
  [FO]="https://raw.githubusercontent.com/UniversalDependencies/UD_Faroese-FarPaHC/master/fo_farpahc-ud-test.conllu"
  [NO]="https://raw.githubusercontent.com/UniversalDependencies/UD_Norwegian-Bokmaal/master/no_bokmaal-ud-test.conllu"
  [DA]="https://raw.githubusercontent.com/UniversalDependencies/UD_Danish-DDT/master/da_ddt-ud-test.conllu"
  [SV]="https://raw.githubusercontent.com/UniversalDependencies/UD_Swedish-LinES/master/sv_lines-ud-test.conllu"
  [GD]="https://raw.githubusercontent.com/UniversalDependencies/UD_Scottish_Gaelic-ARCOSG/master/gd_arcosg-ud-test.conllu"
  [GA]="https://raw.githubusercontent.com/UniversalDependencies/UD_Irish-IDT/master/ga_idt-ud-test.conllu"
  [CY]="https://raw.githubusercontent.com/UniversalDependencies/UD_Welsh-CCG/master/cy_ccg-ud-test.conllu"
  [RO]="https://raw.githubusercontent.com/UniversalDependencies/UD_Romanian-RRT/master/ro_rrt-ud-test.conllu"
  [CA]="https://raw.githubusercontent.com/UniversalDependencies/UD_Catalan-AnCora/master/ca_ancora-ud-test.conllu"
  [IT]="https://raw.githubusercontent.com/UniversalDependencies/UD_Italian-ISDT/master/it_isdt-ud-test.conllu"
  [HI]="https://raw.githubusercontent.com/UniversalDependencies/UD_Hindi-HDTB/master/hi_hdtb-ud-test.conllu"
  [UR]="https://raw.githubusercontent.com/UniversalDependencies/UD_Urdu-UDTB/master/ur_udtb-ud-test.conllu"
  [FA]="https://raw.githubusercontent.com/UniversalDependencies/UD_Persian-Seraji/master/fa_seraji-ud-test.conllu"
  [GL]="https://raw.githubusercontent.com/UniversalDependencies/UD_Galician-CTG/master/gl_ctg-ud-test.conllu"
  [AF]="https://raw.githubusercontent.com/UniversalDependencies/UD_Afrikaans-AfriBooms/master/af_afribooms-ud-test.conllu"
  [HE]="https://raw.githubusercontent.com/UniversalDependencies/UD_Hebrew-HTB/master/he_htb-ud-test.conllu"
  [AR]="https://raw.githubusercontent.com/UniversalDependencies/UD_Arabic-PADT/master/ar_padt-ud-test.conllu"
  [MT]="https://raw.githubusercontent.com/UniversalDependencies/UD_Maltese-MUDT/master/mt_mudt-ud-test.conllu"
)

if [ -d temp_for_labels ]; then
    rm -rf temp_for_labels
    echo "DELETED dir temp_for_labels"
fi

mkdir temp_for_labels
cd temp_for_labels

for language in "${languages[@]}"; do

  train_link="${pairs_train[$language]}"
  test_link="${pairs_test[$language]}"

  curl -L $train_link > "train-${language}.txt"
  curl -L $test_link > "test-${language}.txt"

  cat train-${language}.txt | grep -v "^#" | cut -f 2,4 | tr '\t' ' ' > train-${language}.txt.tmp
  cat test-${language}.txt  | grep -v "^#" | cut -f 2,4 | tr '\t' ' ' > test-${language}.txt.tmp

done

cat *.txt.tmp > fatut.txt.temp
cat fatut.txt.temp | cut -d " " -f 2 | grep -v "^$"| sort | uniq > labels_with_numbers.txt

cat labels_with_numbers.txt | grep ^[a-z,A-Z,_] > "$MAIN_DIR/labels.txt"

# Finished creating labels.txt file

cd $MAIN_DIR
rm -rf temp_for_labels
echo "DELETED dir temp_for_labels"

for language_from in "${languages_run[@]}"; do

  cd $MAIN_DIR

  if [ -d $language_from ]; then
    rm -rf $language_from
    echo "DELETED dir $language_from"
  fi

  mkdir $language_from
  echo "CREATED dir $language_from"
  
  cd $language_from
  echo "Moved to dir: `pwd`"

  train_link="${pairs_train[$language_from]}"
  test_link="${pairs_test[$language_from]}"

  curl -L $train_link > train.txt
  curl -L $test_link > test.txt

  echo "Now train $language_from"
  mkdir $OUTPUT_DIR

  python3 $MAIN_DIR/run_ner.py               \
  --task_type POS                            \
  --data_dir .                               \
  --model_name_or_path $BERT_MODEL           \
  --output_dir $OUTPUT_DIR                   \
  --max_seq_length  $MAX_LENGTH              \
  --num_train_epochs $NUM_EPOCHS             \
  --save_steps $SAVE_STEPS                   \
  --per_device_train_batch_size $BATCH_SIZE  \
  --seed $SEED                               \
  --overwrite_cache 1                        \
  --do_train                                 \
  --do_predict                               \
  --labels $MAIN_DIR/labels.txt  		     
  
  echo "Finish training for language ${language_from}"

  rm -f train.txt
  rm -f test.txt

  for language_to in "${languages[@]}"; do
      cd "${MAIN_DIR}/${language_from}"

      if [ -d $language_to ]; then
        rm -rf $language_to
        echo "DELETED TRAINED DIR!"
      fi
      mkdir $language_to

      cp $OUTPUT_DIR "${language_to}/${TRAINED_DIR}" -br

      cd "${MAIN_DIR}/${language_from}/${language_to}"
      
      # rm -f test.txt
      # echo "DELETED test.txt"

      test_link="${pairs_test[$language_to]}"
      curl -L $test_link > test.txt

      tested_dir="output-${language_from}-${language_to}"

      echo "Now test $language_to after train on $language_from"

      python3 $MAIN_DIR/run_ner.py                              \
      --task_type POS                                           \
      --data_dir .                                              \
      --output_dir $tested_dir                                  \
      --model_name_or_path $TRAINED_DIR		                \
      --max_seq_length  $MAX_LENGTH                             \
      --num_train_epochs $NUM_EPOCHS                            \
      --per_device_train_batch_size $BATCH_SIZE                 \
      --seed $SEED                                              \
      --save_steps $SAVE_STEPS                                  \
      --overwrite_cache 1                                       \
      --do_predict                                              \
      --labels $MAIN_DIR/labels.txt 			

      rm -f test.txt
      echo "Finish testing $language_to after train on $language_from"
  done
done

