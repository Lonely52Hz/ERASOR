FROM ros:melodic-ros-base-bionic

MAINTAINER weikai

ENV PATH="/opt/conda/bin:${PATH}"
ARG PATH="/opt/conda/bin:${PATH}"

SHELL ["/bin/bash", "-c"]

WORKDIR /home

RUN apt update -y 
RUN DEBIAN_FRONTEND=noninteractive apt install apt-utils software-properties-common -y 
RUN add-apt-repository universe 
RUN add-apt-repository restricted 
RUN add-apt-repository multiverse 
RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install ros-melodic-jsk-recognition ros-melodic-jsk-common-msgs ros-melodic-jsk-rviz-plugins python-rosbag -y
RUN apt-get install ros-melodic-catkin python3-catkin-tools -y
RUN apt-get install wget -y
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh
RUN bash Miniconda3-py310_22.11.1-1-Linux-x86_64.sh -u -b -p /opt/conda
RUN rm -f Miniconda3-py310_22.11.1-1-Linux-x86_64.sh
RUN echo "export PATH=/opt/conda/bin:$PATH" >> ~/.bashrc
RUN source ~/.bashrc
RUN conda init bash
RUN conda create --name erasor python=2.7
SHELL ["conda", "run", "-n", "erasor", "/bin/bash", "-c"]
RUN pip install --no-cache-dir pypcd
RUN pip install --no-cache-dir tqdm	
RUN pip install --no-cache-dir scikit-learn
RUN pip install --no-cache-dir tabulate

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /home/*
RUN conda clean -a
RUN mkdir -p /home/wzhoea/Desktop/

CMD cd /home/wzhoea/Desktop

# docker build -t erasor:1 .
# docker run -it --name erasor -v /home/wzhoea/Desktop/:/home/wzhoea/Desktop/ erasor:1 /bin/bash

# cd /home/wzhoea/Desktop/erasor && source /opt/ros/noetic/setup.bash && catkin build erasor -DPYTHON_EXECUTABLE=/usr/bin/python3 && source devel/setup.bash
# cd /home/wzhoea/Desktop/erasor && source /opt/ros/melodic/setup.bash && catkin build erasor -DPYTHON_EXECUTABLE=/usr/bin/python && source devel/setup.bash
# roslaunch erasor mapgen.launch ##### remember to modify /home/wzhoea/Desktop/erasor/src/ERASOR/launch/mapgen.launch
# roslaunch erasor run_erasor.launch ##### remember to change target_seq in run_erasor.lunch file
# rosbag play 05_2350_to_2670_w_interval_2_node.bag 
# rostopic pub /saveflag std_msgs/Float32 "data: 0.2"
# python kitti2node.py -t None -r None -s 00 --kitti_type "odom_noimg" --init_stamp 4390 --end_stamp 4530 --dir /media/wzhoea/T7/kitti_dataset/ --savedir /media/wzhoea/T7/my_erasor_dataset/   
