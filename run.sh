echo ">>> Download model link url ..."
wget https://paddle-qa.bj.bcebos.com/fullchain_ce_test/model_download_link/tipc_models_url_PaddleClas_latest.txt
wget https://paddle-qa.bj.bcebos.com/fullchain_ce_test/model_download_link/tipc_models_url_PaddleDetection_latest.txt
wget https://paddle-qa.bj.bcebos.com/fullchain_ce_test/model_download_link/tipc_models_url_PaddleGAN_latest.txt
wget https://paddle-qa.bj.bcebos.com/fullchain_ce_test/model_download_link/tipc_models_url_PaddleOCR_latest.txt
wget https://paddle-qa.bj.bcebos.com/fullchain_ce_test/model_download_link/tipc_models_url_PaddleVideo_latest.txt
wget https://paddle-qa.bj.bcebos.com/fullchain_ce_test/model_download_link/tipc_models_url_PaddleSeg_latest.txt

dir=$(pwd)
paddle_reop_list=(PaddleClas PaddleDetection PaddleGAN PaddleOCR PaddleVideo PaddleSeg)
echo ">>> Download model ..."
cd Models
for paddle_repo in ${paddle_reop_list[@]};do
    paddle_repo_url="tipc_models_url_${paddle_repo}_latest.txt"
    echo ">>> ${paddle_repo} model download and decompression..."
    cat ${dir}/${paddle_repo_url} | while read line
    do
        wget -q $line
        tar -xf *tgz
        if [ $? -eq 0 ]; then
            rm -rf *tgz
            model_name=$(ls |grep _upload)
            mv ${model_name} ${model_name%_upload*}
            echo ${model_name%_upload*}
        else
            echo "${$line} decompression failed"
        fi
    done
done
cd ${dir}
echo ">>> Generate yaml configuration file ..."
bash prepare_config.sh

echo ">>> Run onnx_convert and converted model diff checker ..."
bash onnx_convert.sh

echo ">>> Run inference_benchmark ..."
bash inference_benchmark.sh

echo ">>> generate tipc_benchmark_excel.xlsx..."
python result2xlsx.py

echo ">>> Tipc benchmark done"
