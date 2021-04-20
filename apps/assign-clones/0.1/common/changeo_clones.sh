#
# ChangeO clone assignment
#
# TODO: this script should be runnable in parallel using launcher
#
# Author: Scott Christley
# Date: Apr 20, 2021
# 

        file=$1
        echo $file
        fileOutname="${file##*/}"
        echo $fileOutname
        #noArchive $fileOutname

        # save filenames for later processing
        fileBasename="${fileOutname%.*}"
        fileBasename="${fileBasename%.*}"
        parseName="${fileBasename}.airr_parse-select.tsv"
        echo $fileBasename
        echo $fileName

        # clonal assignment on only the productive rearrangements
        ParseDb.py select -d ${file} -f productive -u T | tee productive.log
        newFile="${fileBasename}.productive.airr.tsv"
        mv $parseName $newFile
        summaryName="${fileBasename}.productive.airr.json"
        python3 parse_changeo.py productive.log $summaryName

        filteredFile="${fileBasename}.productive.airr.tsv"
        fileName="${fileBasename}.productive.airr_clone-pass.tsv"
        failName="${fileBasename}.productive.airr_clone-fail.tsv"

        # find the threshold that DefineClones needs
        rm -f threshold.dat
        (time -p find_threshold.R -d $filteredFile -o threshold.dat) 2> timing.dat
        cat threshold.dat
        threshold="0.16"
        if [ -f threshold.dat ]; then
            threshold=$(cat threshold.dat)
            rm -f threshold.dat
        fi

        # allele mode
        echo DefineClones.py -d $filteredFile --mode allele --act set --model ham --norm len --dist $threshold --failed
        DefineClones.py -d $filteredFile --mode allele --act set --model ham --norm len --dist $threshold --failed | tee allele.clone.log
        newPass="${fileBasename}.allele.clone.airr.tsv"
        newFail="${fileBasename}.allele.clone-fail.airr.tsv"
        mv $fileName $newPass
        mv $failName $newFail
        summaryName="${fileBasename}.summary.allele.clone.airr.json"
        python3 parse_changeo.py allele.clone.log $summaryName
        
        # gene mode
        echo DefineClones.py -d $filteredFile --mode gene --act set --model ham --norm len --dist $threshold --failed
        DefineClones.py -d $filteredFile --mode gene --act set --model ham --norm len --dist $threshold --failed | tee gene.clone.log
        newPass="${fileBasename}.gene.clone.airr.tsv"
        newFail="${fileBasename}.gene.clone-fail.airr.tsv"
        mv $fileName $newPass
        mv $failName $newFail
        summaryName="${fileBasename}.summary.gene.clone.airr.json"
        python3 parse_changeo.py gene.clone.log $summaryName
