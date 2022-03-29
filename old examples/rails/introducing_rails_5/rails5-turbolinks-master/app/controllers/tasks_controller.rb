class TasksController < ApplicationController
  before_action :task, only: [:show, :update, :destroy]

  def show
  end

  def new
    @task = Task.new
    @notes = Note.last(3)
  end

  def create
    @task = Task.new(tasks_params)

    if @task.save
      redirect_to new_task_url
    else
      render :new
    end
  end

  def update
    @task.update_attribute(:status, tasks_params[:status]) if @task
    redirect_to new_task_url
  end

  def destroy
    @task.destroy
    redirect_to new_task_url
  end

  private

  def tasks_params
    params.require(:task).permit(:id, :name, :status)
  end

  def task
    @task ||= Task.find(params[:id])
  end
end
