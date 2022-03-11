echo ">>> Donwnload model link url ..."
wget https://paddle-qa.bj.bcebos.com/fullchain_ce_test/model_download_link/tipc_models_url.txt

echo ">>> Donwnload model ..."
cd Models
cat ../tipc_models_url.txt | while read line
do
    wget -q $line
    tar -xf *tgz
    cd norm_train_gpus_0,1_autocast_null_upload
    whole_name=$(ls *txt)
    echo ${whole_name%%_train_infer*}
    model_name=${whole_name%%_train_infer*}
    cd ..
    mv norm_train_gpus_0,1_autocast_null_upload ${model_name}
    rm -rf *tgz
done

echo ">>> Generate yaml configuration file ..."
bash prepare_config.sh

echo ">>> Run onnx_convert and converted model diff checker ..."
bash onnx_convert.sh

echo ">>> Run inference_benchmark ..."
bash inference_benchmark.sh

echo ">>> generate tipc_benchmark_excel.xlsx..."
python result2xlsx.py

echo ">>> Tipc benchmark done"
