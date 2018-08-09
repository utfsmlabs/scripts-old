for i in $(cat pcs/lds pcs/lpa)
do
    ssh-keyscan $i >> $HOME/.ssh/known_hosts 
done
