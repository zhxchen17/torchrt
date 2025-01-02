set -ex

pushd pytorch

CONDA_ACTIVE_ENV=`conda info | awk -F 'active environment : ' '{print $2}' | xargs`

if [ "$CONDA_ACTIVE_ENV" = "None" ] || [ "$CONDA_ACTIVE_ENV" = "base" ]; then
    echo "Conda required."
    exit
fi

git submodule update --init --recursive
pip install -r requirements.txt
BUILD_SHARED_LIBS=OFF _GLIBCXX_USE_CXX11_ABI=1 USE_CUDA=1 USE_NCCL=1 USE_STATIC_NCCL=1 BUILD_CAFFE2_OPS=0 BUILD_TEST=0 USE_MKLDNN=0 USE_QNNPACK=0 USE_OPENMP=0 USE_PYTORCH_QNNPACK=0 USE_NNPACK=0 USE_XNNPACK=0 USE_FBGEMM=0 USE_TENSORPIPE=0 python setup.py install --prefix=./install

popd

rm -rf build
mkdir build
mkdir build/lib
mkdir build/include

cp -r pytorch/torch/lib/*.a build/lib/
cp -r pytorch/build/nccl/lib/*.a build/lib/
cp -r pytorch/build/lib/*.a build/lib/

cp -r pytorch/torch/include/* build/include/
