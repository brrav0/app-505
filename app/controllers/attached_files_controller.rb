class AttachedFilesController < ApplicationController
  def index
    @attachedfiles = AttachedFile.all
  end

  def new
    @attachedfile = AttachedFile.new
    
    attachOrigin = params[:attach_origin] # conf_new/
    
    puts "new attachOrigin: " + attachOrigin
  end

  def create
    @attachedfile = AttachedFile.new(attachedfile_params)
    @attachedfile.is_audit = true
    @attachedfile.is_bank = false
    
    attachOrigin = params[:attach_origin] # conf_new/
    puts "create attachOrigin: " + attachOrigin

      if @attachedfile.save
      	
      	# We need to let the bank account to get access to this object.
      	# To do so, we will serialised it and store it in the session.
      	# Thus the bank account can retrieve it from the session.
      	session[:last_attachedfile] = @attachedfile.to_yaml
        
        redirect_to '/confirmations/new'
      else
        render "new"
      end
  end

  def destroy
    @attachedfile = AttachedFile.find(params[:id])
    @attachedfile.destroy
    redirect_to attached_files_path
  end
  
private
  def attachedfile_params
    params.require(:attached_file).permit(:name, :attachment, :signed_bank)
  end
end
