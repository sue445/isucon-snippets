environment "production"

port '8000', '0.0.0.0'

threads 0, 32

workers 32

preload_app!

log_requests false

# for puma 5+
# Recommended 0.001~0.010(default 0.005)
wait_for_less_busy_worker 0.005

nakayoshi_fork true