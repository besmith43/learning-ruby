import javax.swing.JMenu;
import javax.swing.KeyStroke;

public class CustomJMenu
{
	public static JMenu Create(String title)
	{
		return new JMenu(title) {
			private KeyStroke accelerator;

			@Override
			public KeyStroke getAccelerator()
			{
				return accelerator;
			}

			@Override
			public void setAccelerator(KeyStroke keyStroke)
			{
				KeyStroke oldAccelerator = accelerator;
				this.accelerator = keyStroke;
				repaint();
				revalidate();
				firePropertyChange("accelerator", oldAccelerator, accelerator);
			}
		};
	}
}
