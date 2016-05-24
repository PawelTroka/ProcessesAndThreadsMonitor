using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace ProcessesAndThreadsMonitorUI
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private PSInterfacer psInterfacer;
        
        public MainWindow()
        {
            InitializeComponent();
            psInterfacer = new PSInterfacer(this.outputRichTextBox);
        }

        private async void button_Click(object sender, RoutedEventArgs e)
        {
            var text = inputRichTextBox.Text;
            button.IsEnabled = false;
           await Task.Run(() => psInterfacer.RunScript(text));
            button.IsEnabled = true;

            /**
            var rs = RunspaceFactory.CreateRunspace();
            rs.ThreadOptions = PSThreadOptions.UseCurrentThread;
            rs.Open();
            
            rs.SessionStateProxy.SetVariable("textbox", this.outputRichTextBox);
            var ps = PowerShell.Create();
           
            ps.Runspace = rs;
            ps.AddScript(inputRichTextBox.Text);
            ps.Invoke();
            rs.Close();**/
        }
    }
}
