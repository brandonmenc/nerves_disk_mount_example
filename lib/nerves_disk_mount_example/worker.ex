defmodule NervesDiskMountExample.Worker do
  use GenServer

  @partition "sda1"
  @device "/dev/#{@partition}"
  @mount_point "/mnt"
  @special_file "/mnt/nerves_disk_mount_example.txt"

  defmodule State do
    defstruct [:partition_available, :partition_mounted]
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    SystemRegistry.register()

    {:ok, %{}}
  end

  def handle_info({:system_registry, :global, registry}, state) do
    if partition_available?(registry) do
      if partition_mounted?(registry) do
        make_special_file()
      else
        mount()
        # notice that we don't make the file here - we let the mount state
        # update and then cycle through this callback again
      end
    end

    {:noreply, state}
  end

  def make_special_file do
    if !File.exists?(@special_file) do
      File.write!(@special_file, "hello!\n")
    end
  end

  def partition_available?(registry) do
    registry
    |> get_in([:state, :disks, :partitions])
    |> Enum.any?(&(&1 == @partition))
  end

  def partition_mounted?(registry) do
    registry
    |> get_in([:state, :mounts, :mounts])
    |> Enum.find(false, fn mount ->
      mount[:device] == @device && mount[:mount_point] == @mount_point
    end)
  end

  def mount do
    System.cmd("mount", ["-o", "flush", @device, @mount_point])
  end

  def unmount do
    System.cmd("umount", [@mount_point])
  end
end
