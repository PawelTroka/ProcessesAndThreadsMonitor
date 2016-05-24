using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Windows.Controls;

namespace ProcessesAndThreadsMonitorUI
{
    internal class PSInterfacer
    {
        private readonly Runspace runspace;
        private TextBox outpuTextBox;
        public PSInterfacer(TextBox outpuTextBox)
        {
            this.outpuTextBox = outpuTextBox;
            runspace = RunspaceFactory.CreateRunspace();
            runspace.Open();
        }

        public void RunScript(string script)
        {
            //       string tempOut = "";
            //  try
            {
                using (PowerShell ps = PowerShell.Create())
                {
                    ps.Runspace = runspace;
                    ps.AddScript(script);
                    ps.AddCommand("Out-String");
                    ps.Commands.Commands[0].MergeMyResults(PipelineResultTypes.Error, PipelineResultTypes.Output);

                    var iasyncResult = ps.BeginInvoke();
                    //List<PSObject> psOutputs = ps.EndInvoke(iasyncResult).ToList();//ps.Invoke().ToList();

                    foreach (PSObject psObject in ps.EndInvoke(iasyncResult))
                    {
                        if (psObject != null)
                        {
                            outpuTextBox.Dispatcher.Invoke(() => outpuTextBox.AppendText(psObject.ToString()));
                            //tempOut += psObject.BaseObject;
                            // yield return psObject.BaseObject.ToString();
                        }
                    }
                }
            }
            //  catch (Exception ex)
            {
                //    tempOut = string.Format("Error when invoking powershell commands:\n{0}", ex.Message);
                //  tempOut += "\nThis function did not complete.";
            }
            //return tempOut;
        }
    }
}