FROM ros:humble

RUN apt-get update

RUN apt-get install -y bash-completion\
    less htop tmux xterm gosu python3-pip git vim nano python3-pip python-is-python3 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/

ENV USERNAME circuit_crusher
ARG USER_ID=1000
ARG GROUP_ID=15214

RUN groupadd --gid $GROUP_ID $USERNAME && \
        useradd --gid $GROUP_ID -m $USERNAME && \
        echo "$USERNAME:$USERNAME" | chpasswd && \
        usermod --shell /bin/bash $USERNAME && \
        usermod -aG sudo $USERNAME && \
        usermod  --uid $USER_ID $USERNAME && \
        echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
        chmod 0440 /etc/sudoers.d/$USERNAME
RUN su ${USERNAME} -c "rosdep update"
RUN echo "export ROS_HOSTNAME=\"\$(hostname -I | awk '{print \$1;}')\"" >> /home/$USERNAME/.bashrc
RUN echo "export ROS_IP=\"\$(hostname -I | awk '{print \$1;}')\"" >> /home/$USERNAME/.bashrc
RUN echo 'echo "ROS_HOSTNAME=>$ROS_HOSTNAME<"' >> /home/$USERNAME/.bashrc
RUN echo 'echo "ROS_IP=>$ROS_IP<"' >> /home/$USERNAME/.bashrc


RUN mkdir -p /home/$USERNAME/dev_ws/src &&\
    cd /home/$USERNAME/dev_ws && \
    /ros_entrypoint.sh colcon build
RUN chown $USERNAME:$USERNAME --recursive /home/$USERNAME/dev_ws
RUN echo "source /opt/ros/humble/setup.bash" >> /home/$USERNAME/.bashrc
RUN echo "source /home/$USERNAME/dev_ws/install/setup.bash" >> /home/$USERNAME/.bashrc

RUN pip3 install --upgrade pip

COPY ./docker_install /home/$USERNAME/docker_install
RUN bash /home/$USERNAME/docker_install/install_vim.sh "${USERNAME}"
RUN rm -rf /home/$USERNAME/docker_install
RUN apt-get update && apt-get install -y --no-install-recommends python-is-python3
RUN pip3 install numpy

RUN su ${USERNAME} -c "echo 'if [ -z \"\$TMUX\" ] && [ \"\$TERM_PROGRAM\" != \"vscode\" ] && [ -z \"\$SESSION_MANAGER\" ]; then tmux attach -t default || tmux new -s default; fi' >> /home/${USERNAME}/.bashrc"

COPY ros_entrypoint.sh /
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT [ "/ros_entrypoint.sh" ]
