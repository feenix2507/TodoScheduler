-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE OR ALTER PROCEDURE repeatScheduler
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
-- exec filbert
declare @y as int = 1
declare @interval as nvarchar(max)
declare @lastdate as datetime
declare @newID as nvarchar(max)
declare @searchTodoID as nvarchar(max)
declare @doUpdate as int = 0

while(@y <= (select count(*) from RepeatTodo))
Begin
   set @interval = (select a.interval from( select ROW_NUMBER() over(order by TodoID) Num,* from RepeatTodo) a where Num = @y)
   set @lastdate = (select a.LastRepeatedDate from( select ROW_NUMBER() over(order by TodoID) Num,* from RepeatTodo) a where Num = @y)
   set @searchTodoID = (select a.ToDoID from( select ROW_NUMBER() over(order by TodoID) Num,* from RepeatTodo) a where Num = @y) 
   set @doUpdate = 0

   IF(@interval = 'every-day')
     Begin
		set @newID = newID()
		insert into ToDo (TodoID, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, isDeleted, isCompleted, DueDate, PersonID, Title, ChannelURL, CompletedDate, isRepeated, RepeatedTodoID)
		select @newID,CreatedBy, ModifiedBy, getDate(), getDate(), 0, 0, getDate(), PersonID, Title, NULL, NULL, 0, NULL from ToDo 
		where TodoID in (select a.TodoID from ToDo a JOIN RepeatToDo b on a.TodoID = @searchToDoID) 

		set @doUpdate = 1
	 End
   Else if(@interval = 'every-3-days')
   Begin
		IF (Ceiling(Datediff(day, @lastdate, getDate())) = 3)
			Begin
				set @newID = newID()
				insert into ToDo (TodoID, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, isDeleted, isCompleted, DueDate, PersonID, Title, ChannelURL, CompletedDate, isRepeated, RepeatedTodoID)
				select @newID,CreatedBy, ModifiedBy, getDate(), getDate(), 0, 0, getDate(), PersonID, Title, NULL, NULL, 0, NULL from ToDo 
				where TodoID in (select a.TodoID from ToDo a JOIN RepeatToDo b on a.TodoID = @searchToDoID)

				set @doUpdate = 1
			End
   End
   Else if(@interval = 'every-week')
   Begin
		IF (Ceiling(Datediff(day, @lastdate, getDate())) = 7)
			Begin
				set @newID = newID()
				insert into ToDo (TodoID, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, isDeleted, isCompleted, DueDate, PersonID, Title, ChannelURL, CompletedDate, isRepeated, RepeatedTodoID)
				select @newID,CreatedBy, ModifiedBy, getDate(), getDate(), 0, 0, getDate(), PersonID, Title, NULL, NULL, 0, NULL from ToDo 
				where TodoID in (select a.TodoID from ToDo a JOIN RepeatToDo b on a.TodoID = @searchToDoID)

				set @doUpdate = 1
			End
   End
   Else if(@interval = 'every-month')
   Begin
		IF (substring(cast(@lastdate as varchar), 5,2) = substring(cast(getDate() as varchar), 5,2))
			Begin
				set @newID = newID()
				insert into ToDo (TodoID, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, isDeleted, isCompleted, DueDate, PersonID, Title, ChannelURL, CompletedDate, isRepeated, RepeatedTodoID)
				select @newID,CreatedBy, ModifiedBy, getDate(), getDate(), 0, 0, getDate(), PersonID, Title, NULL, NULL, 0, NULL from ToDo 
				where TodoID in (select a.TodoID from ToDo a JOIN RepeatToDo b on a.TodoID = @searchToDoID)

				set @doUpdate = 1
			End
   End
  -- Else if(@interval = 'every-year')
  -- Begin
		--IF (substring(cast(@lastdate as varchar), 1,6) = substring(cast(getDate() as varchar), 1,6))
		--	Begin
		--		set @newID = newID()
		--		insert into ToDo (TodoID, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, isDeleted, isCompleted, DueDate, PersonID, Title, ChannelURL, CompletedDate, isRepeated, RepeatedTodoID)
		--		select @newID,CreatedBy, ModifiedBy, getDate(), getDate(), 0, 0, getDate(), PersonID, Title, NULL, NULL, 0, NULL from ToDo 
		--		where TodoID in (select a.TodoID from ToDo a JOIN RepeatToDo b on a.TodoID = @searchToDoID)
		--	End
  -- End

   set @y = @y+1

   -- Update ToDoID in RepeatToDo Table

   IF(@doUpdate = 1)
   Begin
		update RepeatToDo set TodoID = @newID, LastRepeatedDate = getDate() where TodoID = @searchTodoID;
   End

End



END
GO
