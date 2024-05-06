import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import threading
import time

class MinimalPublisher(Node):

    def __init__(self):
        super().__init__('minimal_publisher')
        self.publisher_1 = self.create_publisher(String, 'topic1', 1)
        self.publisher_2 = self.create_publisher(String, 'topic2', 1)
        self.timer_period = 0.01  # seconds
        self.timer_thread = threading.Thread(target=self.publish_messages)

    def publish_messages(self):
        while rclpy.ok():
            msg1 = String()
            msg1.data = 'Hello, ROS 2 from topic1!'
            self.publisher_1.publish(msg1)
            self.get_logger().info('Publishing to topic1: "%s"' % msg1.data)

            msg2 = String()
            msg2.data = 'Hello, ROS 2 from topic2!'
            self.publisher_2.publish(msg2)
            self.get_logger().info('Publishing to topic2: "%s"' % msg2.data)

            time.sleep(self.timer_period)  # Use time.sleep for delay

    def start(self):
        self.timer_thread.start()

    def stop(self):
        self.timer_thread.join()

def main(args=None):
    rclpy.init(args=args)
    minimal_publisher = MinimalPublisher()
    minimal_publisher.start()
    rclpy.spin(minimal_publisher)
    minimal_publisher.stop()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
